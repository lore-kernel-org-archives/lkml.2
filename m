Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1KZNLR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 08:11:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45781 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab1KZNLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 08:11:14 -0500
Message-ID: <1322313066.6001.3.camel@phoenix>
Subject: [PATCH] char: hw_random: convert drivers/char/hw_random/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Clouter <alex@digriz.org.uk>,
        David Daney <ddaney@caviumnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Jamie Iles <jamie@jamieiles.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Matt Mackall <mpm@selenic.com>, Olof Johansson <olof@lixom.net>
Date: Sat, 26 Nov 2011 21:11:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/char/hw_random/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Alexander Clouter <alex@digriz.org.uk>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jamie Iles <jamie@jamieiles.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/char/hw_random/atmel-rng.c      |   12 +-----------
 drivers/char/hw_random/n2-drv.c         |   13 +------------
 drivers/char/hw_random/octeon-rng.c     |   13 +------------
 drivers/char/hw_random/pasemi-rng.c     |   12 +-----------
 drivers/char/hw_random/picoxcell-rng.c  |   12 +-----------
 drivers/char/hw_random/ppc4xx-rng.c     |   12 +-----------
 drivers/char/hw_random/timeriomem-rng.c |   13 +------------
 7 files changed, 7 insertions(+), 80 deletions(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index 241df2e..f518b99 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -141,17 +141,7 @@ static struct platform_driver atmel_trng_driver = {
 	},
 };
 
-static int __init atmel_trng_init(void)
-{
-	return platform_driver_register(&atmel_trng_driver);
-}
-module_init(atmel_trng_init);
-
-static void __exit atmel_trng_exit(void)
-{
-	platform_driver_unregister(&atmel_trng_driver);
-}
-module_exit(atmel_trng_exit);
+module_platform_driver(atmel_trng_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Peter Korsgaard <jacmet@sunsite.dk>");
diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index c3de70d..ebd48f0 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -770,15 +770,4 @@ static struct platform_driver n2rng_driver = {
 	.remove		= __devexit_p(n2rng_remove),
 };
 
-static int __init n2rng_init(void)
-{
-	return platform_driver_register(&n2rng_driver);
-}
-
-static void __exit n2rng_exit(void)
-{
-	platform_driver_unregister(&n2rng_driver);
-}
-
-module_init(n2rng_init);
-module_exit(n2rng_exit);
+module_platform_driver(n2rng_driver);
diff --git a/drivers/char/hw_random/octeon-rng.c b/drivers/char/hw_random/octeon-rng.c
index 9cd0fec..0943edc 100644
--- a/drivers/char/hw_random/octeon-rng.c
+++ b/drivers/char/hw_random/octeon-rng.c
@@ -131,18 +131,7 @@ static struct platform_driver octeon_rng_driver = {
 	.remove		= __exit_p(octeon_rng_remove),
 };
 
-static int __init octeon_rng_mod_init(void)
-{
-	return platform_driver_register(&octeon_rng_driver);
-}
-
-static void __exit octeon_rng_mod_exit(void)
-{
-	platform_driver_unregister(&octeon_rng_driver);
-}
-
-module_init(octeon_rng_mod_init);
-module_exit(octeon_rng_mod_exit);
+module_platform_driver(octeon_rng_driver);
 
 MODULE_AUTHOR("David Daney");
 MODULE_LICENSE("GPL");
diff --git a/drivers/char/hw_random/pasemi-rng.c b/drivers/char/hw_random/pasemi-rng.c
index 1d50481..3a63267 100644
--- a/drivers/char/hw_random/pasemi-rng.c
+++ b/drivers/char/hw_random/pasemi-rng.c
@@ -148,17 +148,7 @@ static struct platform_driver rng_driver = {
 	.remove		= rng_remove,
 };
 
-static int __init rng_init(void)
-{
-	return platform_driver_register(&rng_driver);
-}
-module_init(rng_init);
-
-static void __exit rng_exit(void)
-{
-	platform_driver_unregister(&rng_driver);
-}
-module_exit(rng_exit);
+module_platform_driver(rng_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Egor Martovetsky <egor@pasemi.com>");
diff --git a/drivers/char/hw_random/picoxcell-rng.c b/drivers/char/hw_random/picoxcell-rng.c
index 990d55a..97bd891 100644
--- a/drivers/char/hw_random/picoxcell-rng.c
+++ b/drivers/char/hw_random/picoxcell-rng.c
@@ -191,17 +191,7 @@ static struct platform_driver picoxcell_trng_driver = {
 	},
 };
 
-static int __init picoxcell_trng_init(void)
-{
-	return platform_driver_register(&picoxcell_trng_driver);
-}
-module_init(picoxcell_trng_init);
-
-static void __exit picoxcell_trng_exit(void)
-{
-	platform_driver_unregister(&picoxcell_trng_driver);
-}
-module_exit(picoxcell_trng_exit);
+module_platform_driver(picoxcell_trng_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jamie Iles");
diff --git a/drivers/char/hw_random/ppc4xx-rng.c b/drivers/char/hw_random/ppc4xx-rng.c
index b8afa6a..c51762c 100644
--- a/drivers/char/hw_random/ppc4xx-rng.c
+++ b/drivers/char/hw_random/ppc4xx-rng.c
@@ -139,17 +139,7 @@ static struct platform_driver ppc4xx_rng_driver = {
 	.remove = ppc4xx_rng_remove,
 };
 
-static int __init ppc4xx_rng_init(void)
-{
-	return platform_driver_register(&ppc4xx_rng_driver);
-}
-module_init(ppc4xx_rng_init);
-
-static void __exit ppc4xx_rng_exit(void)
-{
-	platform_driver_unregister(&ppc4xx_rng_driver);
-}
-module_exit(ppc4xx_rng_exit);
+module_platform_driver(ppc4xx_rng_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Josh Boyer <jwboyer@linux.vnet.ibm.com>");
diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index a8428e6..f1a1618 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -149,18 +149,7 @@ static struct platform_driver timeriomem_rng_driver = {
 	.remove		= __devexit_p(timeriomem_rng_remove),
 };
 
-static int __init timeriomem_rng_init(void)
-{
-	return platform_driver_register(&timeriomem_rng_driver);
-}
-
-static void __exit timeriomem_rng_exit(void)
-{
-	platform_driver_unregister(&timeriomem_rng_driver);
-}
-
-module_init(timeriomem_rng_init);
-module_exit(timeriomem_rng_exit);
+module_platform_driver(timeriomem_rng_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alexander Clouter <alex@digriz.org.uk>");
-- 
1.7.5.4



