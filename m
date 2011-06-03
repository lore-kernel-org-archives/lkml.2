Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab1FCBxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 21:53:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61445 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1FCBxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 21:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NGkypvq5l8juMh6T1F2e7xWFsiM01w9emuWdOzr4yurFIwWNcp8pTyzc+eJ4LG8/Ks
         ulIcOW3yK8yhuCmovEuwxAHkQAwuTDVo3qUoa1EImclIcxmjoTkqdPh0G3fZLJ/TPwwS
         6Pd2LfvGCSlLxgJD7z07qpYpEXk4vrCFws9Pk=
Subject: [PATCH 2/2] mtd: nomadik_nand: add missing nand_release in
 nomadik_nand_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sachin Verma <sachin.verma@st.com>, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-mtd@lists.infradead.org
In-Reply-To: <1307065913.10001.2.camel@phoenix>
References: <1307065913.10001.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 09:53:26 +0800
Message-ID: <1307066006.10001.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/nand/nomadik_nand.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/nomadik_nand.c b/drivers/mtd/nand/nomadik_nand.c
index b6a5c86..b463ecf 100644
--- a/drivers/mtd/nand/nomadik_nand.c
+++ b/drivers/mtd/nand/nomadik_nand.c
@@ -187,6 +187,7 @@ static int nomadik_nand_remove(struct platform_device *pdev)
 		pdata->exit();
 
 	if (host) {
+		nand_release(&host->mtd);
 		iounmap(host->cmd_va);
 		iounmap(host->data_va);
 		iounmap(host->addr_va);
-- 
1.7.4.1



