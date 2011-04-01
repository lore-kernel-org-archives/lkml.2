Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab1DAGYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:24:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61781 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab1DAGX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:23:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Clwu3Rm4JZsfK8aN7dVwkJbKnCPpbb8dJvUGrUnmEkx/4xNReYpKOGeA4+au/ctv/L
         r1Uqq4nDitMrNl57dCAyTnb3+FZLzt20HBX7PUrq15PrOCtaJdYa5AztNNUmFH40sgzd
         TxLsaLfBLXsjUIx/7ebFp2kKCQxg6pc0MKGaY=
From: Liu Yuan <namei.unix@gmail.com>
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org (open list:NETEFFECT IWARP R...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drivers/infiniband: Add a check for strict_strtoul()
Date: Fri,  1 Apr 2011 14:23:49 +0800
Message-Id: <1301639029-15251-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

It should check if strict_strtoul() succeeds before using
'wqm_quanta_value'.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 drivers/infiniband/hw/nes/nes.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 13de119..119d60d 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -1138,7 +1138,9 @@ static ssize_t nes_store_wqm_quanta(struct device_driver *ddp,
 	u32 i = 0;
 	struct nes_device *nesdev;
 
-	strict_strtoul(buf, 0, &wqm_quanta_value);
+	if (strict_strtoul(buf, 0, &wqm_quanta_value) < 0)
+		return -EINVAL;
+
 	list_for_each_entry(nesdev, &nes_dev_list, list) {
 		if (i == ee_flsh_adapter) {
 			nesdev->nesadapter->wqm_quanta = wqm_quanta_value;
-- 
1.7.1

