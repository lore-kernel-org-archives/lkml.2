Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab2JJXC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:02:29 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44814 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932482Ab2JJXCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:02:25 -0400
X-Sasl-enc: tu0Ht8EcJ58HxN3n74trZXKfS+Gx7NmMm2/8/KTJ/fLc 1349910144
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        Martin Peschke <mpeschke@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 039/122] SCSI: zfcp: Make trace record tags unique
Date: Thu, 11 Oct 2012 07:53:25 +0900
Message-Id: <20121010225345.177603911@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/scsi/zfcp_fsf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -219,7 +219,7 @@ static void zfcp_fsf_status_read_handler
 		return;
 	}
 
-	zfcp_dbf_hba_fsf_uss("fssrh_2", req);
+	zfcp_dbf_hba_fsf_uss("fssrh_4", req);
 
 	switch (sr_buf->status_type) {
 	case FSF_STATUS_READ_PORT_CLOSED:
@@ -915,7 +915,7 @@ static void zfcp_fsf_send_ct_handler(str
 
 	switch (header->fsf_status) {
         case FSF_GOOD:
-		zfcp_dbf_san_res("fsscth1", req);
+		zfcp_dbf_san_res("fsscth2", req);
 		ct->status = 0;
 		break;
         case FSF_SERVICE_CLASS_NOT_SUPPORTED:


