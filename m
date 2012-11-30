Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992582Ab2K3Szg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:55:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:57567 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031678Ab2K3Stg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:49:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 10/37] SCSI: isci: copy fis 0x34 response into proper buffer
Date: Fri, 30 Nov 2012 10:45:57 -0800
Message-Id: <20121130183858.305888512@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
References: <20121130183857.166228045@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/isci/request.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -1693,7 +1693,7 @@ sci_io_request_frame_handler(struct isci
 								      frame_index,
 								      (void **)&frame_buffer);
 
-			sci_controller_copy_sata_response(&ireq->stp.req,
+			sci_controller_copy_sata_response(&ireq->stp.rsp,
 							       frame_header,
 							       frame_buffer);
 


