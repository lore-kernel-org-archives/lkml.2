Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab1CJJKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 04:10:54 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54830 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab1CJJKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 04:10:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Z6D8hFPimosG5DMMFuGWJNRz0fnxy97a4QfpgwOlNpOhqfdfmutuksISvKWbbEekOy
         kbuovTWGVuXCXiX1fJ4340d9zDtIfNPgYYbN0fNog0LB+JckOxp2xn3j4+4+orraActf
         v7K1FF3sqW39tKuzpe+5XLLB6w32XWwcVyVCk=
Subject: [PATCH] gpio: Use  __devexit at necessary places
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Miguel Gaio <miguel.gaio@efixo.com>,
        Mocean Laboratories <info@mocean-labs.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 10 Mar 2011 17:10:45 +0800
Message-Id: <1299748245.18619.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function gen_74x164_remove and mc33880_remove are used only wrapped
by __devexit_p so define it using __devexit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Miguel Gaio <miguel.gaio@efixo.com>
Cc: Mocean Laboratories <info@mocean-labs.com>
---
 drivers/gpio/74x164.c  |    2 +-
 drivers/gpio/mc33880.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/74x164.c b/drivers/gpio/74x164.c
index d91ff4c..84e0702 100644
--- a/drivers/gpio/74x164.c
+++ b/drivers/gpio/74x164.c
@@ -133,7 +133,7 @@ exit_destroy:
 	return ret;
 }
 
-static int gen_74x164_remove(struct spi_device *spi)
+static int __devexit gen_74x164_remove(struct spi_device *spi)
 {
 	struct gen_74x164_chip *chip;
 	int ret;
diff --git a/drivers/gpio/mc33880.c b/drivers/gpio/mc33880.c
index 935479d..00f6d24 100644
--- a/drivers/gpio/mc33880.c
+++ b/drivers/gpio/mc33880.c
@@ -146,7 +146,7 @@ exit_destroy:
 	return ret;
 }
 
-static int mc33880_remove(struct spi_device *spi)
+static int __devexit mc33880_remove(struct spi_device *spi)
 {
 	struct mc33880 *mc;
 	int ret;
-- 
1.7.2



