Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab0LOUye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:54:34 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:25445 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753131Ab0LOUya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:54:30 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisJACS3CE3O+J1F/2dsb2JhbACjEoEddMN2hUoEhGSLM4JW
X-IronPort-AV: E=Sophos;i="4.59,351,1288584000"; 
   d="scan'208";a="85563561"
From: matthew@wil.cx
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 5/5] uas: Use GFP_NOIO instead of GFP_KERNEL in I/O submission path
Date: Wed, 15 Dec 2010 15:44:06 -0500
Message-Id: <1292445846-12101-5-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101215204147.GA1263@parisc-linux.org>
References: <20101215204147.GA1263@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>

If swap is on a UAS device, we could recurse into the driver by using
GFP_KERNEL.  Using GFP_NOIO ensures we won't.

Reported-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/usb/storage/uas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 0ebe7f6..23f0dd9 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -141,7 +141,7 @@ static void uas_do_work(struct work_struct *work)
 		struct scsi_pointer *scp = (void *)cmdinfo;
 		struct scsi_cmnd *cmnd = container_of(scp,
 							struct scsi_cmnd, SCp);
-		uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_KERNEL);
+		uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_NOIO);
 	}
 }
 
-- 
1.7.2.3

