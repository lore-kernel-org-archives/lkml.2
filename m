Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761995Ab0HFTxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:53:09 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46135 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935082Ab0HFTw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:52:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rnpHGEAfwUcj9NAxUSqdkYqR2H+QOwlNTb3RgN5pCKStliLJKO34018rX4naRZW7XI
         bfggsAJ5/+wM+NBJI2wEi7i8vHDxFnC0EjDPiBXtR6/5DeeIOU6XECFIKMxYrEBr4hWk
         DS01+5tEAWK05qwry7bFmMpvQitUKM5o4BFrE=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jarod Wilson <jarod@redhat.com>,
        Manu Abraham <abraham.manu@gmail.com>, Scott Davilla <davilla@4pi.com>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/18] staging: crystalhd: call disable_pci_device() if pci_probe() failed
Date: Fri,  6 Aug 2010 23:52:50 +0400
Message-Id: <1281124373-13756-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver should call disable_pci_device() if it returns from pci_probe()
with error. Also it must not be called if pci_request_region() fails as
it means that somebody uses device resources and rules the device.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/crystalhd/crystalhd_lnx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index fbb80f0..0e52075 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -570,6 +570,8 @@ static int __devinit chd_dec_pci_probe(struct pci_dev *pdev,
 	rc = chd_pci_reserve_mem(pinfo);
 	if (rc) {
 		BCMLOG_ERR("Failed to setup memory regions.\n");
+		if (rc != -EBUSY)
+			pci_disable_device(pdev);
 		return -ENOMEM;
 	}
 
-- 
1.7.0.4

