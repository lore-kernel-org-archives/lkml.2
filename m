Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab1CIImE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 03:42:04 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37326 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab1CIImC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 03:42:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=I5TsnpJDGCJ2k7DykD9QQ1QA2urW+1kGNFpEpazF7X1LfrJ7861hMY5hr6d9ZP7kL6
         QxUy5l/qi3P+Tp/dry9qTp1mzmTPjtkttOYib8Chss16Ns6bhawUsitEWY1BOhPsxm6S
         xgtPShRQ7+DIzOF2R/8PtOanY9HPF0IQgqFX8=
Subject: [PATCH] misc: hmc6352: fix wrong return value checking for
	i2c_master_recv
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kalhan Trisal <kalhan.trisal@intel.com>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 09 Mar 2011 16:41:56 +0800
Message-Id: <1299660116.8255.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_master_recv() returns negative errno, or else the number of bytes read.
Thus i2c_master_recv(client, i2c_data, 2) returns 2 instead of 1 in success case.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/misc/hmc6352.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/hmc6352.c b/drivers/misc/hmc6352.c
index 234bfca..3afc11e 100644
--- a/drivers/misc/hmc6352.c
+++ b/drivers/misc/hmc6352.c
@@ -86,7 +86,7 @@ static ssize_t compass_heading_data_show(struct device *dev,
 	msleep(10); /* sending 'A' cmd we need to wait for 7-10 millisecs */
 	ret = i2c_master_recv(client, i2c_data, 2);
 	mutex_unlock(&compass_mutex);
-	if (ret != 1) {
+	if (ret < 0) {
 		dev_warn(dev, "i2c read data cmd failed\n");
 		return ret;
 	}
-- 
1.7.2



