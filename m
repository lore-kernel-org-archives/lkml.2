Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab2JKMjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 08:39:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55657 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2JKMiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 08:38:54 -0400
MIME-Version: 1.0
In-Reply-To: <1345311022-26328-4-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
	<1345311022-26328-4-git-send-email-andi@firstfloor.org>
Date: Thu, 11 Oct 2012 14:38:53 +0200
X-Google-Sender-Auth: aktDNFzH8bdxCXGV8E63a0Dz658
Message-ID: <CAMuHMdWJCLnWpuNFvQQSJU0w4fQLg6rYbDOQF2But1__NrgiAg@mail.gmail.com>
Subject: Re: [PATCH 03/31] sections: Fix section conflicts in arch/frv
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andi Kleen <andi@firstfloor.org>, David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        James.Bottomley@hansenpartnership.com, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 7:29 PM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/frv/kernel/setup.c         |    2 +-
>  arch/frv/mb93090-mb00/pci-irq.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
> index 75cf7f4..1f1e5ef 100644
> --- a/arch/frv/kernel/setup.c
> +++ b/arch/frv/kernel/setup.c
> @@ -184,7 +184,7 @@ static struct clock_cmode __pminitdata clock_cmodes_fr555[16] = {
>         [6]     = {     _x1,    _x1_5,  _x1_5,  _x4_5,  _x0_375 },
>  };
>
> -static const struct clock_cmode __pminitdata *clock_cmodes;
> +static const struct clock_cmode __pminitconst *clock_cmodes;

Unfortunately __pminitconst isn't defined at this point:
arch/frv/kernel/setup.c:187:47: error: expected '=', ',', ';', 'asm'
or '__attribute__' before '*' token
arch/frv/kernel/setup.c:386:2: error: 'clock_cmodes' undeclared (first
use in this function)
arch/frv/kernel/setup.c:571:6: error: 'clock_cmodes' undeclared (first
use in this function)
make[2]: *** [arch/frv/kernel/setup.o] Error 1

http://kisskb.ellerman.id.au/kisskb/buildresult/7344691/

It seems the __pminit* variants are frv-specific, and don't cover all possible
combinations?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
