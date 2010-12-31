Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0LaP0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 10:26:51 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49407 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab0LaP0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 10:26:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Jf2WzVCKnD23c8i4pLS1qouPUUCEF7iPmj2S8vZEKclMRPLstvm5l9tyi0HYzmsAxk
         J8nOYv5GpwTaEvcJR5kDTKc/nqNuZpzYgFV7MMn8MySoNFYJKzkOWWIpV3chQ8iaZ9Ra
         lgmqc9d40deheCkvBNaG9ObdZUi6M44LfuH/I=
Message-ID: <4D1DF637.1060609@gmail.com>
Date: Fri, 31 Dec 2010 16:26:47 +0100
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] regulator: missing index in PTR_ERR() in isl6271a_probe()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The index is missing so the return is wrong.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/regulator/isl6271a-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index b8cc638..13e2073 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -169,7 +169,7 @@ static int __devinit isl6271a_probe(struct i2c_client *i2c,
 						init_data, pmic);
 		if (IS_ERR(pmic->rdev[i])) {
 			dev_err(&i2c->dev, "failed to register %s\n", id->name);
-			err = PTR_ERR(pmic->rdev);
+			err = PTR_ERR(pmic->rdev[i]);
 			goto error;
 		}
 	}
