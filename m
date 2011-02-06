Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab1BFXpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:45:30 -0500
Received: from 1wt.eu ([62.212.114.60]:60266 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab1BFXp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:45:28 -0500
Message-Id: <20110206232252.955688996@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:23:02 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Saeed Bishara <saeed@marvell.com>, Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 10/23] mv_xor: fix race in tasklet function
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Saeed Bishara <saeed@marvell.com>

commit 8333f65ef094e47020cd01452b4637e7daf5a77f upstream.

use mv_xor_slot_cleanup() instead of __mv_xor_slot_cleanup() as the former function
aquires the spin lock that needed to protect the drivers data.

Signed-off-by: Saeed Bishara <saeed@marvell.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 drivers/dma/mv_xor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: longterm-2.6.27/drivers/dma/mv_xor.c
===================================================================
--- longterm-2.6.27.orig/drivers/dma/mv_xor.c	2011-01-29 11:22:46.657065036 +0100
+++ longterm-2.6.27/drivers/dma/mv_xor.c	2011-01-29 11:27:15.509064355 +0100
@@ -449,7 +449,7 @@
 static void mv_xor_tasklet(unsigned long data)
 {
 	struct mv_xor_chan *chan = (struct mv_xor_chan *) data;
-	__mv_xor_slot_cleanup(chan);
+	mv_xor_slot_cleanup(chan);
 }
 
 static struct mv_xor_desc_slot *


