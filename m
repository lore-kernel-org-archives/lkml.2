Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab1EYDYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:24:05 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53491 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab1EYDYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:24:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=tpfofhXxW/n/K55xiEgha5Jitxp2uToHwX1h7oKff75yxH2TQmY3ZK7h48se8E9wr5
         ARzNn8/Q41OUgl/e1rvUxTsZv21FWTcecP9CXcTisyoLEOhMXooUYfcuF5BMly6DGaAO
         tLuUpKCtklT18ZnVhqBMmjppzPjF2CtlROcv0=
Subject: [PATCH] drivers/misc: fix a memory leak in spear_pcie_gadget_probe
 error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Pratyush Anand <pratyush.anand@st.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 11:23:55 +0800
Message-ID: <1306293835.3358.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of goto err_kzalloc, we should kfree target.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/misc/spear13xx_pcie_gadget.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/spear13xx_pcie_gadget.c b/drivers/misc/spear13xx_pcie_gadget.c
index 7aded90..cfbddbe 100644
--- a/drivers/misc/spear13xx_pcie_gadget.c
+++ b/drivers/misc/spear13xx_pcie_gadget.c
@@ -845,7 +845,7 @@ err_iounmap:
 err_iounmap_app:
 	iounmap(config->va_app_base);
 err_kzalloc:
-	kfree(config);
+	kfree(target);
 err_rel_res:
 	release_mem_region(res1->start, resource_size(res1));
 err_rel_res0:
-- 
1.7.1



