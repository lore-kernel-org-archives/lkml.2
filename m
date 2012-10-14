Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab2JNPDd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:03:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46426 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671Ab2JNOnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:08 -0400
Message-Id: <20121014143546.227254051@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 092/147] iscsit: remove incorrect unlock in iscsit_build_sendtargets_resp
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit 904753da183566c71211d23c169a80184648c121 upstream.

Fix a potential multiple spin-unlock -> deadlock scenario during the
overflow check within iscsit_build_sendtargets_resp() as found by
sparse static checking.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/iscsi/iscsi_target.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index cca6d13..29f3b24 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3274,7 +3274,6 @@ static int iscsit_build_sendtargets_response(struct iscsi_cmd *cmd)
 		len += 1;
 
 		if ((len + payload_len) > buffer_len) {
-			spin_unlock(&tiqn->tiqn_tpg_lock);
 			end_of_buf = 1;
 			goto eob;
 		}


