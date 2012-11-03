Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab2KCUax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 16:30:53 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:15625
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703Ab2KCUad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 16:30:33 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161264925"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Krishna C Gudipati <kgudipat@brocade.com>
Cc: kernel-janitors@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] drivers/scsi/bfa/bfa_svc.c: drop if around WARN_ON
Date: Sat,  3 Nov 2012 21:30:19 +0100
Message-Id: <1351974625-10282-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Just use WARN_ON rather than an if containing only WARN_ON(1).

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@
- if (e) WARN_ON(1);
+ WARN_ON(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/bfa/bfa_svc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 299c1c8..765b8d0 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -626,8 +626,7 @@ bfa_fcxp_init_reqrsp(struct bfa_fcxp_s *fcxp,
 		/*
 		 * alloc required sgpgs
 		 */
-		if (n_sgles > BFI_SGE_INLINE)
-			WARN_ON(1);
+		WARN_ON(n_sgles > BFI_SGE_INLINE);
 	}
 
 }

