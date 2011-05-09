Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab1EIOHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 10:07:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42736 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab1EIOG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 10:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=gWZZJpKHn3vem3I/7Wv7Ccicceed5VHK/9Yxjo94GGFfE7e+5UYCOR0n1DUiAAmBv5
         v9yHXED7USy45OSq23q9MsM4V/1+mBl0c8+RXOlaIq4f1v7XeAmnwiylkCyuVcSvPOEl
         yeWbKPQQCFxBStOdJgFgWf7JOU/dVKmCVpnX8=
Message-ID: <4DC7F4AB.90607@gmail.com>
Date: Mon, 09 May 2011 16:05:31 +0200
From: Vladimir Motyka <vladimir.motyka@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: cjb@laptop.org
CC: kernel-janitors@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/mmc/card/block.c: fix potential null dereference
 'idata'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allocation of idata fails there was a null dereferece.

Signed-off-by: Vladimir Motyka <vladimir.motyka@gmail.com>

---
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 407836d..3dec493 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -266,10 +266,10 @@ static struct mmc_blk_ioc_data
*mmc_blk_ioctl_copy_from_user(
 	return idata;

 copy_err:
-	kfree(idata->buf);
+	if(idata)
+		kfree(idata->buf);
 	kfree(idata);
 	return ERR_PTR(err);
-
 }

 static int mmc_blk_ioctl_cmd(struct block_device *bdev,
