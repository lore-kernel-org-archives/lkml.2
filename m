Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab1AFAf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:35:26 -0500
Received: from kroah.org ([198.145.64.141]:36106 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab1AFAbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:48 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:09 2011
Message-Id: <20110106002309.776735478@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Saeed Bishara <saeed@marvell.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [139/152] mv_xor: fix race in tasklet function
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Saeed Bishara <saeed@marvell.com>

commit 8333f65ef094e47020cd01452b4637e7daf5a77f upstream.

use mv_xor_slot_cleanup() instead of __mv_xor_slot_cleanup() as the former function
aquires the spin lock that needed to protect the drivers data.

Signed-off-by: Saeed Bishara <saeed@marvell.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/dma/mv_xor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -449,7 +449,7 @@ mv_xor_slot_cleanup(struct mv_xor_chan *
 static void mv_xor_tasklet(unsigned long data)
 {
 	struct mv_xor_chan *chan = (struct mv_xor_chan *) data;
-	__mv_xor_slot_cleanup(chan);
+	mv_xor_slot_cleanup(chan);
 }
 
 static struct mv_xor_desc_slot *


