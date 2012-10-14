Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2JNOub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:50:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46717 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932366Ab2JNOoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:04 -0400
Message-Id: <20121014143539.954271222@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        Martin Peschke <mpeschke@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 045/147] [SCSI] zfcp: Make trace record tags unique
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Maier <maier@linux.vnet.ibm.com>

commit 0100998dbfe6dfcd90a6e912ca7ed6f255d48f25 upstream.

Duplicate fssrh_2 from a54ca0f62f953898b05549391ac2a8a4dad6482b
"[SCSI] zfcp: Redesign of the debug tracing for HBA records."
complicates distinction of generic status read response from
local link up.
Duplicate fsscth1 from 2c55b750a884b86dea8b4cc5f15e1484cc47a25c
"[SCSI] zfcp: Redesign of the debug tracing for SAN records."
complicates distinction of good common transport response from
invalid port handle.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/s390/scsi/zfcp_fsf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 30436d5..6e2892e 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -219,7 +219,7 @@ static void zfcp_fsf_status_read_handler(struct zfcp_fsf_req *req)
 		return;
 	}
 
-	zfcp_dbf_hba_fsf_uss("fssrh_2", req);
+	zfcp_dbf_hba_fsf_uss("fssrh_4", req);
 
 	switch (sr_buf->status_type) {
 	case FSF_STATUS_READ_PORT_CLOSED:
@@ -915,7 +915,7 @@ static void zfcp_fsf_send_ct_handler(struct zfcp_fsf_req *req)
 
 	switch (header->fsf_status) {
         case FSF_GOOD:
-		zfcp_dbf_san_res("fsscth1", req);
+		zfcp_dbf_san_res("fsscth2", req);
 		ct->status = 0;
 		break;
         case FSF_SERVICE_CLASS_NOT_SUPPORTED:


