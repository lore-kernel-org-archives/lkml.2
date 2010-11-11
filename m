Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab0KKPEC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:04:02 -0500
Received: from nm1.bullet.mail.ac4.yahoo.com ([98.139.52.198]:24554 "HELO
	nm1.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751233Ab0KKPEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:04:00 -0500
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Nov 2010 10:04:00 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 27408.11299.bm@omp1054.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=WlKs4RGXCqqSEC2iTSu108N1FZk2pqhUdpimD9wH6+zGcpshoedxmXYEpKBjbOS7i83qCN6tbUyX6ABhrCLAulAqIoQ04ta4MxyJYyGR6g3E1F/Sn8QB2B4OA3wVlwMSXfw2JndN6W2Ynkhoxwn77+iUj9Oj635AjNkMnvhHKqU=;
Message-ID: <805862.49452.qm@web51006.mail.re2.yahoo.com>
X-YMail-OSG: FpYNHYAVM1mWkrWbHgyfDYl58dhE62Xt5fhc16plNl3azGV
 KJJteTv7ILyKEDRZQPqTLfnFA8cQAICPbgmO4c5vM7Oynxr.mjCIfzAZbAiR
 XPMto4vST4lLNlT79HpWYQ40DrhBteW_H6.WED_FLTwIExFNgtLkMembQY.h
 n4Kr8lS_YfborXlK8Kz9p6HBVXumHThP77oK.US1yYxrjIeNFhk91dRtdAe7
 y6d0GKyHw3I0vMdA3TVhuYEErCpsBcntbOr9HaDh8RW7SfmxqwxS7Zy3v66e
 fliqNV1gqGn0nAL31jFbWETNREo3RyBHmVv.2bBY2.yihuh.0DxekOu6paOM
 BU8ge8xnrdzWow__umxMTMtBaSkKTuiQLb2gnCw--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Thu, 11 Nov 2010 06:58:14 -0800 (PST)
From: Fabio Estevam <fabioestevam@yahoo.com>
Subject: [PATCH] mfd: check for NULL platform data
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, s.hauer@pengutronix.de,
        u.kleine-koenig@pengutronix.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid kernel crash if platform data is NULL.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/mfd/mc13xxx-core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index a2ac2ed..b4d6bb1 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -757,6 +757,9 @@ err_revision:
 
 	mc13xxx_unlock(mc13xxx);
 
+	if (pdata == NULL)
+		return 0;
+
 	if (pdata->flags & MC13XXX_USE_ADC)
 		mc13xxx_add_subdevice(mc13xxx, "%s-adc");
 
-- 
1.6.0.4



      
