Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab2KZRCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:02:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47220 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab2KZRCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:02:38 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 046/270] iscsit: remove incorrect unlock in iscsit_build_sendtargets_resp
Date: Mon, 26 Nov 2012 14:55:36 -0200
Message-Id: <1353949160-26803-47-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit 904753da183566c71211d23c169a80184648c121 upstream.

Fix a potential multiple spin-unlock -> deadlock scenario during the
overflow check within iscsit_build_sendtargets_resp() as found by
sparse static checking.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d3114d1..6d1d906 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3269,7 +3269,6 @@ static int iscsit_build_sendtargets_response(struct iscsi_cmd *cmd)
 		len += 1;
 
 		if ((len + payload_len) > buffer_len) {
-			spin_unlock(&tiqn->tiqn_tpg_lock);
 			end_of_buf = 1;
 			goto eob;
 		}
-- 
1.7.9.5

