Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab2HYT5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 15:57:19 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:45964
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757545Ab2HYT5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 15:57:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,311,1344204000"; 
   d="scan'208";a="153817997"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Naren Sankar <nsankar@broadcom.com>
Cc: kernel-janitors@vger.kernel.org, Jarod Wilson <jarod@wilsonet.com>,
        Scott Davilla <davilla@4pi.com>, Manu Abraham <abraham.manu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] drivers/staging/crystalhd/crystalhd_lnx.c: adjust inconsistent IS_ERR and PTR_ERR
Date: Sat, 25 Aug 2012 21:57:08 +0200
Message-Id: <1345924629-16584-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345924629-16584-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345924629-16584-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Change the call to PTR_ERR to access the value just tested by IS_ERR.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,e1;
@@

(
if (IS_ERR(e)) { ... PTR_ERR(e) ... }
|
if (IS_ERR(e=e1)) { ... PTR_ERR(e) ... }
|
*if (IS_ERR(e))
 { ...
*  PTR_ERR(e1)
   ... }
)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/crystalhd/crystalhd_lnx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 5909d8d..166203a 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -381,7 +381,7 @@ static int __devinit chd_dec_init_chdev(struct crystalhd_adp *adp)
 	dev = device_create(crystalhd_class, NULL, MKDEV(adp->chd_dec_major, 0),
 			    NULL, "crystalhd");
 	if (IS_ERR(dev)) {
-		rc = PTR_ERR(crystalhd_class);
+		rc = PTR_ERR(dev);
 		BCMLOG_ERR("failed to create device\n");
 		goto device_create_fail;
 	}

