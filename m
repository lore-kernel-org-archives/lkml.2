Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab0KQC4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 21:56:19 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56593 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab0KQC4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 21:56:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=sFRc5P8Xm7OftsNlXyCOO88uW7jjO56MsruSEQ0tlsHO2hRZzIdgNwQgGu+KKQa+Sb
         hxDl7AIp8mB2LLuUtcGDBIOeUDN6b05ce+g/eE05G4RKZaUrCxR4VLwKykITNzp+ejAy
         M9G07KB+Z38IjyzEAveyJeE7RIdIm6X27bUOU=
Subject: [PATCH] regulator: Move lp3971 regulator driver to
	subsys_initcall()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain
Date: Wed, 17 Nov 2010 11:00:44 +0800
Message-Id: <1289962844.8233.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulators need to be available early in init in order to allow them
to be available for consumers when requested.

Other regulator drivers are already moved to subsys_initcall(),
looks like only lp3971 is missing.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/lp3971.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 0f22ef1..40520d9 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -554,7 +554,7 @@ static int __init lp3971_module_init(void)
 
 	return ret;
 }
-module_init(lp3971_module_init);
+subsys_initcall(lp3971_module_init);
 
 static void __exit lp3971_module_exit(void)
 {
-- 
1.7.2



