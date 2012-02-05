Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab2BEWnj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:43:39 -0500
Received: from 1wt.eu ([62.212.114.60]:61900 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab2BEW0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:23 -0500
Message-Id: <20120205220951.077338767@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:27 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 38/91] ALSA: timer - Fix Oops at closing slave timer
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 0584ffa548b6e59aceb027112f23a55f0133400e upstream.

A slave-timer instance has no timer reference, and this results in
NULL-dereference at stopping the timer, typically called at closing
the device.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=40682

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/core/timer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/sound/core/timer.c
===================================================================
--- longterm-2.6.27.orig/sound/core/timer.c	2012-02-05 22:34:33.866915229 +0100
+++ longterm-2.6.27/sound/core/timer.c	2012-02-05 22:34:40.244919877 +0100
@@ -527,6 +527,8 @@
 	if (err < 0)
 		return err;
 	timer = timeri->timer;
+	if (!timer)
+		return -EINVAL;
 	spin_lock_irqsave(&timer->lock, flags);
 	timeri->cticks = timeri->ticks;
 	timeri->pticks = 0;


