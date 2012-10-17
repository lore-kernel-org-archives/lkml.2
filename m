Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab2JQOsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:48:01 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:61431 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab2JQOsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:48:00 -0400
MIME-Version: 1.0
In-Reply-To: <20121017141536.29084.8653.stgit@warthog.procyon.org.uk>
References: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
	<20121017141536.29084.8653.stgit@warthog.procyon.org.uk>
Date: Wed, 17 Oct 2012 16:47:58 +0200
X-Google-Sender-Auth: VYCKv_zp2O-veHMkewwTxoHz9WY
Message-ID: <CAMuHMdUdw=jZxEmMkNenD4eXCzFHe7V9o+wa_EpctJ_igeFwBg@mail.gmail.com>
Subject: Re: [PATCH 02/10] UAPI: Make uapi/linux/irqnr.h non-empty
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Alessandro Suardi <alessandro.suardi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 4:15 PM, David Howells <dhowells@redhat.com> wrote:
> uapi/linux/irqnr.h was emitted by the UAPI disintegration script as an empty
> file because the parent linux/irqnr.h had no UAPI stuff in it, despite being
> marked with "header-y".

> --- a/include/uapi/linux/irqnr.h
> +++ b/include/uapi/linux/irqnr.h
> @@ -0,0 +1,4 @@
> +/*
> + * There isn't anything here anymore, but the file must not be empty or patch
> + * will delete it.
> + */

Wouldn't it be better to just have include guards in those otherwise
empty files?

If someone needs to add something to such a file, the include guards are needed
anyway (but may be forgotten), and the comment should be deleted as well
(which may also be forgotten).

BTW, is "#pragma once" allowed these days? It seems we already have one
user in drivers/staging/bcm/CmHost.h.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
