Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab2BEW0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:49 -0500
Received: from 1wt.eu ([62.212.114.60]:62030 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab2BEW0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:44 -0500
Message-Id: <20120205220952.314304561@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:56 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 67/91] offb: Fix bug in calculating requested vram size
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit c055fe0797b7bd8f6f21a13598a55a16d5c13ae7 upstream.

We used to try to request 8 times more vram than needed, which would
fail if the card has a too small BAR (observed with qemu & kvm).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/video/offb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/drivers/video/offb.c
===================================================================
--- longterm-2.6.27.orig/drivers/video/offb.c	2012-02-05 22:34:44.268915456 +0100
+++ longterm-2.6.27/drivers/video/offb.c	2012-02-05 22:34:44.406915262 +0100
@@ -368,7 +368,7 @@
 				int pitch, unsigned long address,
 				int foreign_endian, struct device_node *dp)
 {
-	unsigned long res_size = pitch * height * (depth + 7) / 8;
+	unsigned long res_size = pitch * height;
 	struct offb_par *par = &default_par;
 	unsigned long res_start = address;
 	struct fb_fix_screeninfo *fix;


