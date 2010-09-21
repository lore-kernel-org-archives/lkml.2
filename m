Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab0IUEwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 00:52:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33057 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab0IUEwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 00:52:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=mTWWlX1TwWltVL4a7UQOB8VBdqoUy/zvDwXm0X2+IBYENVIS4HzObTnilgY9/LvJQU
         RonFO4femtmdLzlQ9FpIHlIedEYEzWIipXD3jrPl2ao1/+NBt02msAytUwbcA1WanuJn
         wCdImLFP39cgGn1Jx1e7+2ZbrYKb2yqGRqp7U=
MIME-Version: 1.0
In-Reply-To: <1285042724-19135-1-git-send-email-justinmattock@gmail.com>
References: <1285042724-19135-1-git-send-email-justinmattock@gmail.com>
From: Matt Turner <mattst88@gmail.com>
Date: Tue, 21 Sep 2010 00:52:02 -0400
Message-ID: <AANLkTinE73z9QV0zriVE3bRtzMifWSGvG36hfvnA9biD@mail.gmail.com>
Subject: Re: [PATCH]Update-broken-web-addresses-in-the-kernel
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Ben Pfaff <blp@cs.stanford.edu>, Mike Frysinger <vapier.adi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 12:18 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> Signed-off-by: Matt Turner <mattst88@gmail.com>

Yeah... I didn't give my sign off.

[snip]

> diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
> index b9647bb..8da39ce 100644
> --- a/arch/alpha/Kconfig
> +++ b/arch/alpha/Kconfig
> @@ -219,7 +219,7 @@ config ALPHA_LX164
>        bool "LX164"
>        help
>          A technical overview of this board is available at
> -         <http://www.unix-ag.org/Linux-Alpha/Architectures/LX164.html>.
> +         <http://www.alphalinux.org/>.
>
>  config ALPHA_LYNX
>        bool "Lynx"
> @@ -483,7 +483,7 @@ config ALPHA_AVANTI
>        help
>          Avanti AS 200, AS 205, AS 250, AS 255, AS 300, and AS 400-based
>          Alphas. Info at
> -         <http://www.unix-ag.org/Linux-Alpha/Architectures/Avanti.html>.
> +         <http://www.alphalinux.org/>.
>
>  config ALPHA_BROKEN_IRQ_MASK
>        bool
> diff --git a/arch/alpha/kernel/sys_sio.c b/arch/alpha/kernel/sys_sio.c
> index 85b4aea..c5051aa 100644
> --- a/arch/alpha/kernel/sys_sio.c
> +++ b/arch/alpha/kernel/sys_sio.c
> @@ -154,7 +154,7 @@ noname_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
>         * bridge (PIRQ0-PIRQ3).  The table below is based on
>         * information available at:
>         *
> -        *   http://ftp.digital.com/pub/DEC/axppci/ref_interrupts.txt
> +        *  http://web.archive.org/web/*/http://ftp.digital.com/pub/DEC/axppci/ref_interrupts.txt
>         *
>         * I have no information on the Avanti interrupt routing, but
>         * the routing seems to be identical to the Noname except

This change looks harmless. After all, it's changing a comment. But wait.

You're adding a */ into a block comment, thereby prematurely closing
the comment and breaking compilation.

I imagine that any other places you've changed the link to archive.org
has the same problem.

I appreciate the work, but please drop arch/alpha from your patch.
I'll go through and fix those links at the same time as I update a lot
of other Kconfig information.

Matt
