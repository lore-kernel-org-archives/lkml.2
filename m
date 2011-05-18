Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab1ERFFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:05:50 -0400
Received: from nm7-vm2.bullet.mail.ne1.yahoo.com ([98.138.90.155]:25067 "HELO
	nm7-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750918Ab1ERFFt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:05:49 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 May 2011 01:05:48 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 302911.50013.bm@omp1033.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=UaYN+84AWH/FrqwTnqLWBGmaDaYp8sw4b1hAzkd+2a1AEmHhiM/M+u/7lv2HNhaN0Ld2+D3ap0ydakPqMXtbmtamL6G/loWaPBrMTO6BWkjT8cydbY7LiVs1BmbxgXv8NtFiopJik6lMKNRD0b2F3WsHeiGHTchigYHvUtxmj/c=;
Message-ID: <204176.97974.qm@web120507.mail.ne1.yahoo.com>
X-YMail-OSG: s1pAp7gVM1mrAgZflnMswBwb6oRW92deT65AaY28ToSH7XC
 ErzPvfGE4xNjj9ZhyLeR7N4p4pYjnDLbn_oNa1l_58vsGt2F0SRpTAnOyrpW
 sKIEJHcftNgs3z9BVNR9MG7ycJ9LZl422IgT0uvF.2hk9fqFNkpQkz4d84Av
 fRmR.4XblPiHMnDpqG4UoYRoWij3_iBBEZmjGnt8lJU8UmxBiGVKdWc0TEr7
 IJEckIT7WV7voD69BX.v3XfJBH3IUYpiGK.N_0vRepy4SfdZgiNwGNr0dx2f
 yioEj4oZSUvLPPeznGqWcVzxMqs0P.eGFD8XCkG5xrxtnirLAGx93sDktude
 VOZt.hRw66UCedI92qW6c6aMLyZYyBwogCJ_BzdopbIjB8.ZE1HYofjRU9vf
 U3zJojaKYMDkJpesxfQ--
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.111.303096
Date: Tue, 17 May 2011 22:00:03 -0700 (PDT)
From: Dennis Aberilla <denzzzhome@yahoo.com>
Subject: [PATCH v2] rtc: rtc-ds1390/rtc-ds3234/rtc-m41t94: eliminate compile warning
To: linux-kernel@vger.kernel.org
Cc: axel.lin@gmail.com, Mark Jackson <mpfj@mimc.co.uk>,
        "Kim B. Heino" <Kim.Heino@bluegiga.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>

These drivers are registered as spi drivers,
thus use spi_get_drvdata instead of platform_get_drvdata.

This patch eliminates the following compile warning:
drivers/rtc/rtc-ds1390.c: In function 'ds1390_remove':
drivers/rtc/rtc-ds1390.c:161: warning: passing argument 1 of 'platform_get_drvdata' from incompatible pointer type
drivers/rtc/rtc-ds3234.c: In function 'ds3234_remove':
drivers/rtc/rtc-ds3234.c:161: warning: passing argument 1 of 'platform_get_drvdata' from incompatible pointer type
drivers/rtc/rtc-m41t94.c: In function 'm41t94_remove':
drivers/rtc/rtc-m41t94.c:139: warning: passing argument 1 of 'platform_get_drvdata' from incompatible pointer type

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off by: Dennis Aberilla <denzzzhome@yahoo.com>
Cc: Mark Jackson <mpfj@mimc.co.uk>
Cc: Kim B. Heino <Kim.Heino@bluegiga.com>

---
 drivers/rtc/rtc-ds1390.c |    2 +-
 drivers/rtc/rtc-ds3234.c |    2 +-
 drivers/rtc/rtc-m41t94.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-ds1390.c b/drivers/rtc/rtc-ds1390.c
index 26a86d2..b038d2c 100644
--- a/drivers/rtc/rtc-ds1390.c
+++ b/drivers/rtc/rtc-ds1390.c
@@ -158,7 +158,7 @@ static int __devinit ds1390_probe(struct spi_device *spi)
 
 static int __devexit ds1390_remove(struct spi_device *spi)
 {
-    struct ds1390 *chip = platform_get_drvdata(spi);
+    struct ds1390 *chip = spi_get_drvdata(spi);
 
     rtc_device_unregister(chip->rtc);
     kfree(chip);
diff --git a/drivers/rtc/rtc-ds3234.c b/drivers/rtc/rtc-ds3234.c
index a774ca3..bbd2622 100644
--- a/drivers/rtc/rtc-ds3234.c
+++ b/drivers/rtc/rtc-ds3234.c
@@ -158,7 +158,7 @@ static int __devinit ds3234_probe(struct spi_device *spi)
 
 static int __devexit ds3234_remove(struct spi_device *spi)
 {
-    struct rtc_device *rtc = platform_get_drvdata(spi);
+    struct rtc_device *rtc = spi_get_drvdata(spi);
 
     rtc_device_unregister(rtc);
     return 0;
diff --git a/drivers/rtc/rtc-m41t94.c b/drivers/rtc/rtc-m41t94.c
index c8c97a4..e259ed7 100644
--- a/drivers/rtc/rtc-m41t94.c
+++ b/drivers/rtc/rtc-m41t94.c
@@ -136,7 +136,7 @@ static int __devinit m41t94_probe(struct spi_device *spi)
 
 static int __devexit m41t94_remove(struct spi_device *spi)
 {
-    struct rtc_device *rtc = platform_get_drvdata(spi);
+    struct rtc_device *rtc = spi_get_drvdata(spi);
 
     if (rtc)
         rtc_device_unregister(rtc);

-- 

I'm happy with this. Thanks.

|Dennis




