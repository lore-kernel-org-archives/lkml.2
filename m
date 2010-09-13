Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab0IMR7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:59:48 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39986 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab0IMR7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JTdEQJYot4h7z6ww8DeCEtK2vwChNEpm83Px8alhWIPFoIhMIV9yhR1QXK9eKcD4ND
         U5KJ7CQKlYBTAmqHKHThOnUAdilW5m+60V0oc1t4/ordi6ZL7uNUmGSigJU6A3Dksuod
         XSNPlEOtT3XSrwRcidBLIyHKvqKqyM4y8Uiac=
MIME-Version: 1.0
In-Reply-To: <20100910161038.20226.59718.stgit@warthog.procyon.org.uk>
References: <20100910161002.20226.27995.stgit@warthog.procyon.org.uk>
	<20100910161038.20226.59718.stgit@warthog.procyon.org.uk>
Date: Mon, 13 Sep 2010 19:59:44 +0200
X-Google-Sender-Auth: ODmlzciE6zgEV2sMuiM0fae-oH4
Message-ID: <AANLkTikpv5OhESRUbQ5f3MqwD0UgO2BrRLGjK1ricv42@mail.gmail.com>
Subject: Re: [PATCH 07/17] Drop a couple of unnecessary asm/system.h inclusions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, torvalds@osdl.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 18:10, David Howells <dhowells@redhat.com> wrote:
> Drop inclusions of asm/system.h from linux/hardirq.h and linux/list.h as
> they're no longer required and prevent the M68K arch's IRQ flag handling macros
> from being made into inlined functions due to circular dependencies.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Greg Ungerer <gerg@uclinux.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>
>  include/linux/hardirq.h |    1 -
>  include/linux/list.h    |    1 -
>  2 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> index d5b3876..7dfdc06 100644
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -8,7 +8,6 @@
>  #include <linux/lockdep.h>
>  #include <linux/ftrace_irq.h>
>  #include <asm/hardirq.h>
> -#include <asm/system.h>
>
>  /*
>  * We put the hardirq and softirq counter into the preemption
> diff --git a/include/linux/list.h b/include/linux/list.h
> index d167b5d..88a0006 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -5,7 +5,6 @@
>  #include <linux/stddef.h>
>  #include <linux/poison.h>
>  #include <linux/prefetch.h>
> -#include <asm/system.h>
>
>  /*
>  * Simple doubly linked list implementation.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
