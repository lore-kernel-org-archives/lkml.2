Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab0HITvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:51:55 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44082 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab0HITvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rUtuDuV5Hpk1R7mmyL9Nr7mXh1ib6IXZAVq7kRD2AIaWj7NhbLAr/3J/5u5OvNbM04
         BQNAPz3U5dVIBb7swjmgM3ihGobIwewv/SVvys/ZRPTy7jb22MazFycOmDFSY4ve35Qr
         7kBnjSQcMI/unq5uL0KdWgwil25k3aCOGqLUM=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jarod Wilson <jarod@redhat.com>,
        Manu Abraham <abraham.manu@gmail.com>, Scott Davilla <davilla@4pi.com>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/18 v2] staging: crystalhd: call disable_pci_device() if pci_probe() failed
Date: Mon,  9 Aug 2010 23:51:44 +0400
Message-Id: <1281383506-14438-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver should call disable_pci_device() if it returns from pci_probe()
with error.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/crystalhd/crystalhd_lnx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index fbb80f0..115e79b 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -570,6 +570,7 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 	rc = chd_pci_reserve_mem(pinfo);
 	if (rc) {
 		BCMLOG_ERR("Failed to setup memory regions.\n");
+		pci_disable_device(pdev);
 		return -ENOMEM;
 	}
 
-- 
1.7.0.4

