Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab0LOUyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:54:12 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:33935 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752158Ab0LOUyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:54:11 -0500
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Dec 2010 15:54:11 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai0JACS3CE3O+J1F/2dsb2JhbACVUo1AgR10w3aFSgSEZIwfgWo
X-IronPort-AV: E=Sophos;i="4.59,351,1288584000"; 
   d="scan'208";a="85563557"
From: matthew@wil.cx
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 2/5] uas: Use kzalloc instead of kmalloc
Date: Wed, 15 Dec 2010 15:44:03 -0500
Message-Id: <1292445846-12101-2-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101215204147.GA1263@parisc-linux.org>
References: <20101215204147.GA1263@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>

The IUs are not being fully initialised by the driver (due to the reserved
space).  Since we should be zeroing reserved fields, use kzalloc to do
it for us.

Reported-by: Luben Tuikov <ltuikov@yahoo.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/usb/storage/uas.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index ca277c2..981fdef 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -297,7 +297,7 @@ static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 	if (!urb)
 		goto out;
 
-	iu = kmalloc(sizeof(*iu), gfp);
+	iu = kzalloc(sizeof(*iu), gfp);
 	if (!iu)
 		goto free;
 
@@ -328,7 +328,7 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 	if (len < 0)
 		len = 0;
 	len = ALIGN(len, 4);
-	iu = kmalloc(sizeof(*iu) + len, gfp);
+	iu = kzalloc(sizeof(*iu) + len, gfp);
 	if (!iu)
 		goto free;
 
-- 
1.7.2.3

