Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1EKQdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:33:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45474 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab1EKQdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:33:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pqtHx4hjeoXrtbMtTvifTDc319jolrBVVRyTovWX5sNzAiL9FjOWGV4EOQabKzzUSr
         vWmkEr4TFo2K3C0aoPQ+ozNPEYm3TATXKwkWHwNgmRKwjcuwm/rtCtbLwnsmlpNBD66m
         Jfu1xCFxecMVs83aVljibJhcvp/SjbgZD7Efc=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105101656310.15037@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104282000200.1563@ayla.of.borg>
	<alpine.DEB.2.00.1104281420140.21665@chino.kir.corp.google.com>
	<1304026464.2598.36.camel@mulgrave.site>
	<alpine.DEB.2.00.1104281437010.21665@chino.kir.corp.google.com>
	<1304521355.2810.21.camel@mulgrave.site>
	<alpine.DEB.2.00.1105041203250.22426@chino.kir.corp.google.com>
	<1304979845.4865.58.camel@mulgrave.site>
	<alpine.DEB.2.00.1105101656310.15037@chino.kir.corp.google.com>
Date: Wed, 11 May 2011 09:27:14 +0200
X-Google-Sender-Auth: 5sIoaECN875UKHCwlY6hTs7x0tU
Message-ID: <BANLkTikf9Qtp1nq8E9sDjEgoYUO-25vsWQ@mail.gmail.com>
Subject: Re: [patch] slub: Revert "[PARISC] slub: fix panic with DISCONTIGMEM"
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Rientjes <rientjes@google.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, stable@kernel.org,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 02:08, David Rientjes <rientjes@google.com> wrote:
> On Mon, 9 May 2011, James Bottomley wrote:
>> > Great, and if that works out successfully this time around I think we'll
>> > either need to fix each individual arch Kconfig that we know doesn't work
>> > well (at least parisc because of the scheduling issue) so that it at least
>> > enables CONFIG_NUMA implicitly for discontigmem unless CONFIG_BROKEN is
>> > set.
>>
>> OK, I confirm that the N_NORMAL_MEMORY patch on its own fixes slub for
>> us.  We can revert the mark slub BROKEN in DISCONTIGMEM && !NUMA patch.
>>
>
> Ok, so we need to revert 4a5fa3590f09 ([PARISC] slub: fix panic with
> DISCONTIGMEM) that did not allow CONFIG_SLUB to be set for architectures
> that use DISCONTIGMEM without NUMA support unless they have CONFIG_BROKEN
> set from Linus' tree _and_ from the stable trees.
>
>
>
> slub: Revert "[PARISC] slub: fix panic with DISCONTIGMEM"
>
> 4a5fa3590f09 ([PARISC] slub: fix panic with DISCONTIGMEM) did not allow
> SLUB to be used on architectures that use DISCONTIGMEM without compiling
> NUMA support without CONFIG_BROKEN also set.
>
> The slub panic that it was intended to prevent is addressed by
> d9b41e0b54fd ([PARISC] set memory ranges in N_NORMAL_MEMORY when onlined)
> on parisc so there is no further slub issues with such a configuration.

Please also refer to the N_NORMAL_MEMORY fixes for the other arches,
esp. for stable.

> This reverts the former commit so that SLUB may now be used on such
> architectures since there haven't been any reports of additional errors.
>
> Cc: James Bottomley <James.Bottomley@suse.de>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@kernel.org

> ---
>  init/Kconfig |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1226,7 +1226,6 @@ config SLAB
>          per cpu and per node queues.
>
>  config SLUB
> -       depends on BROKEN || NUMA || !DISCONTIGMEM
>        bool "SLUB (Unqueued Allocator)"
>        help
>           SLUB is a slab allocator that minimizes cache line usage

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
