Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab1CQDFC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 23:05:02 -0400
Received: from nm23.bullet.mail.ne1.yahoo.com ([98.138.90.86]:21167 "HELO
	nm23.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751202Ab1CQDFA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 23:05:00 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 881431.13225.bm@omp1002.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=bSPWX1kd0Wa6qicd3Y9QQN1y17Vb3KatyYbwHJOw5whyfbjoofFmiKWRFveTP0/GIqZ8PtwIUWEbzypToihZnEkrn3s9lvEcpOng8vYlz4QCkVREiRgfkQ+S23L+MI02YRKQavHkVPA7lrfUio8L1c+hmff17C5tnp+Grd0aHI8=;
Message-ID: <694698.37646.qm@web120506.mail.ne1.yahoo.com>
X-YMail-OSG: VHmwbccVM1kseHMMjlSeUJQolTNe.o2QdUvlLuR9Z0CHGiE
 OaJqqUPhQfTZZL4fnivIjLmkp3dB98plW3ijyc5g3xdn9mJ9Ce.IwbZx1DC6
 2fVjb5NqZRDwS2Rt5zTRNSwHXOYtlYa33_a32UBDmobSyZOT.DIjW9QumMxh
 72zxkDn.6gmjqkiIPrjAOzrLrpw8W26cjN6JIK1A1CAOoand6d8MixP_hMuB
 ouTwZRNNtxBoTgYi9RowFmPs.RsHokcJPeATdupvKfZuBhnWgbrsjIm45324
 IYsBxQ8NiNnc0AY2q33b54FxCji55ug8SUx6uJaoBKRR5PGvfpoGxfvY.54e
 lxHes0Rz8BwMyPMm9hkgF7IWXNF8-
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.109.295617
Date: Wed, 16 Mar 2011 20:04:59 -0700 (PDT)
From: Dennis Aberilla <denzzzhome@yahoo.com>
Subject: Re: [PATCH] rtc: rtc-ds1390/rtc-ds3234/rtc-m41t94: eliminate compile warning
To: linux-kernel@vger.kernel.org, Axel Lin <axel.lin@gmail.com>
Cc: Mark Jackson <mpfj@mimc.co.uk>, "Kim B. Heino" <Kim.Heino@bluegiga.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel, that doesn't seem to make sense to me since "platform_get_drvdata" is (from include/linux/platform_device.h):

#define platform_get_drvdata(_dev)      dev_get_drvdata(&(_dev)->dev)

|Dennis


--- On Thu, 24/2/11, Axel Lin <axel.lin@gmail.com> wrote:

From: Axel Lin <axel.lin@gmail.com>
Subject: [PATCH] rtc: rtc-ds1390/rtc-ds3234/rtc-m41t94: eliminate compile warning
To: linux-kernel@vger.kernel.org
Cc: "Mark Jackson" <mpfj@mimc.co.uk>, "Dennis Aberilla" <denzzzhome@yahoo.com>, "Kim B. Heino" <Kim.Heino@bluegiga.com>, "Alessandro Zummo" <a.zummo@towertech.it>, "Thomas Gleixner" <tglx@linutronix.de>, rtc-linux@googlegroups.com
Received: Thursday, 24 February, 2011, 9:28 AM

Eliminate the following compile warning:
drivers/rtc/rtc-ds1390.c: In function 'ds1390_remove':
drivers/rtc/rtc-ds1390.c:161: warning: passing argument 1 of 'platform_get_drvdata' from incompatible pointer type
drivers/rtc/rtc-ds3234.c: In function 'ds3234_remove':
drivers/rtc/rtc-ds3234.c:161: warning: passing argument 1 of 'platform_get_drvdata' from incompatible pointer type
drivers/rtc/rtc-m41t94.c: In function 'm41t94_remove':
drivers/rtc/rtc-m41t94.c:139: warning: passing argument 1 of 'platform_get_drvdata' from incompatible pointer type

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Mark Jackson <mpfj@mimc.co.uk>
Cc: Dennis Aberilla <denzzzhome@yahoo.com>
Cc: Kim B. Heino <Kim.Heino@bluegiga.com>
---
 drivers/rtc/rtc-ds1390.c |    2 +-
 drivers/rtc/rtc-ds3234.c |    2 +-
 drivers/rtc/rtc-m41t94.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-ds1390.c b/drivers/rtc/rtc-ds1390.c
index 26a86d2..4832248 100644
--- a/drivers/rtc/rtc-ds1390.c
+++ b/drivers/rtc/rtc-ds1390.c
@@ -158,7 +158,7 @@ static int __devinit ds1390_probe(struct spi_device *spi)
 
 static int __devexit ds1390_remove(struct spi_device *spi)
 {
-    struct ds1390 *chip = platform_get_drvdata(spi);
+    struct ds1390 *chip = dev_get_drvdata(&spi->dev);
 
     rtc_device_unregister(chip->rtc);
     kfree(chip);
diff --git a/drivers/rtc/rtc-ds3234.c b/drivers/rtc/rtc-ds3234.c
index a774ca3..07a558e 100644
--- a/drivers/rtc/rtc-ds3234.c
+++ b/drivers/rtc/rtc-ds3234.c
@@ -158,7 +158,7 @@ static int __devinit ds3234_probe(struct spi_device *spi)
 
 static int __devexit ds3234_remove(struct spi_device *spi)
 {
-    struct rtc_device *rtc = platform_get_drvdata(spi);
+    struct rtc_device *rtc = dev_get_drvdata(&spi->dev);
 
     rtc_device_unregister(rtc);
     return 0;
diff --git a/drivers/rtc/rtc-m41t94.c b/drivers/rtc/rtc-m41t94.c
index c8c97a4..21e6091 100644
--- a/drivers/rtc/rtc-m41t94.c
+++ b/drivers/rtc/rtc-m41t94.c
@@ -136,7 +136,7 @@ static int __devinit m41t94_probe(struct spi_device *spi)
 
 static int __devexit m41t94_remove(struct spi_device *spi)
 {
-    struct rtc_device *rtc = platform_get_drvdata(spi);
+    struct rtc_device *rtc = dev_get_drvdata(&spi->dev);
 
     if (rtc)
         rtc_device_unregister(rtc);
-- 
1.7.2






      
