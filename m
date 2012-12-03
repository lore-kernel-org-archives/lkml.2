Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab2LCOgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:36:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43803 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932289Ab2LCOgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:33 -0500
Message-Id: <20121203143154.758485113@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:38 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 52/89] [SCSI] isci: copy fis 0x34 response into proper buffer
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/isci/request.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index c1bafc3..9594ab6 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -1972,7 +1972,7 @@ sci_io_request_frame_handler(struct isci_request *ireq,
 								      frame_index,
 								      (void **)&frame_buffer);
 
-			sci_controller_copy_sata_response(&ireq->stp.req,
+			sci_controller_copy_sata_response(&ireq->stp.rsp,
 							       frame_header,
 							       frame_buffer);
 


