Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab2LMOHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:07:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44475 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab2LMOHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:07:19 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 106/241] isci: copy fis 0x34 response into proper buffer
Date: Thu, 13 Dec 2012 11:57:51 -0200
Message-Id: <1355407206-17100-107-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Patelczyk <maciej.patelczyk@intel.com>

commit 49bd665c5407a453736d3232ee58f2906b42e83c upstream.

SATA MICROCODE DOWNALOAD fails on isci driver. After receiving Register
Device to Host (FIS 0x34) frame Initiator resets phy.
In the frame handler routine response (FIS 0x34) was copied into wrong
buffer and upper layer did not receive any answer which resulted in
timeout and reset.
This patch corrects this bug.

Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/scsi/isci/request.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 7a0431c..94483c9 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -1972,7 +1972,7 @@ sci_io_request_frame_handler(struct isci_request *ireq,
 								      frame_index,
 								      (void **)&frame_buffer);
 
-			sci_controller_copy_sata_response(&ireq->stp.req,
+			sci_controller_copy_sata_response(&ireq->stp.rsp,
 							       frame_header,
 							       frame_buffer);
 
-- 
1.7.9.5

