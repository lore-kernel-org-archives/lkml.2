Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab0EaJam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:30:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33553 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab0EaJal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:30:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=xsIp3xIrKO/Sx6GrTWB8RKK/aI3aX+djItrAQast1zhYlszeoaFE/lmkgOKbh8zlgs
         DhVaSELmnkfMJ/8F/Kd8tjM2Kj1W3tsLDg5pJt9JqupGSmWS6EL9SbOkfu8b5YKbLhRG
         uuK6Tv7m/0E3czWjz9lNun9XkNmYZ7v8a/KIY=
Subject: [PATCH] mfd-core: properly handle platform_device_add_resources
	fail in mfd_add_device
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Ian Molton <spyro@f2s.com>, Dmitry Baryshkov <dbaryshkov@gmail.com>
Content-Type: text/plain
Date: Mon, 31 May 2010 17:30:55 +0800
Message-Id: <1275298255.23779.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_device_add_resources may fail, thus add error checking for it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/mfd-core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 7dd76bc..1823a57 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -70,7 +70,9 @@ static int mfd_add_device(struct device *parent, int id,
 			goto fail_res;
 	}
 
-	platform_device_add_resources(pdev, res, cell->num_resources);
+	ret = platform_device_add_resources(pdev, res, cell->num_resources);
+	if (ret)
+		goto fail_res;
 
 	ret = platform_device_add(pdev);
 	if (ret)
-- 
1.5.4.3



