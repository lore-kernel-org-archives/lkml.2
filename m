Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab1J2MYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 08:24:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32897 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab1J2MYU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 08:24:20 -0400
MIME-Version: 1.0
In-Reply-To: <20111025112629.GA10864@kroah.com>
References: <20111025112629.GA10864@kroah.com>
Date: Sat, 29 Oct 2011 14:24:19 +0200
X-Google-Sender-Auth: IzA30CprK97KhcC5q8ZCl7ZTnSA
Message-ID: <CAMuHMdW0YfSp6D9C2Jf_4UXFRtnys89Bb-woq1EQkxDx8CARQg@mail.gmail.com>
Subject: Re: [GIT PATCH] big staging merge for 3.2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 13:26, Greg KH <greg@kroah.com> wrote:
> Greg Kroah-Hartman (27):
>      Staging: remove drivers/char/scc.h as it should have gone a while ago

That's commit 1ec3ba93c5fad9dca0dab272491c625fe6a2f67d
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Wed Aug 24 14:44:13 2011 -0700

    Staging: remove drivers/char/scc.h as it should have gone a while ago

    This was needed by one of the generic serial drivers that was removed a
    while ago.  No one even noticed that the driver could not be built
    properly while it was in the staging directory.

    So this removed the unneeded .h file.

    Reported-by: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/drivers/char/scc.h b/drivers/char/scc.h
deleted file mode 100644
index 341b114..0000000
--- a/drivers/char/scc.h
+++ /dev/null
@@ -1,613 +0,0 @@
-/*
- * atari_SCC.h: Definitions for the Am8530 Serial Communications Controller

Funny, Google doesn't seem to find any evidence this patch has ever been
posted on a public maling list?

Anyone, no real harm done.

Just for the record, there are two reason no one noticed that
drivers/staging/generic_serial/vme_scc.c no longer compiled:
  1. linux-next doesn't build staging,
  2. The m68k tree still has the (too long) work-in-progress atari_scc driver.
     The Atari SCC driver was the original user of scc.h, so when I moved that
     one to drivers/staging/ in the m68k tree, it masked compile
failures for vme_scc
     in mainline.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
