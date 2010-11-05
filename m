Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab0KEHWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 03:22:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36306 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab0KEHWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 03:22:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pEEN8saifHFl4pHzRKfkUZn6TmY8QowSX1dQekDJb3Laq8q0EPbtjnn5EfkcJAzTsv
         TAaTTUrDWdIl02vHt+3SP5HjawsWk+SASj0KOMIkTTuQwiWNNUA4sHwDzOC6w6FLOQZH
         1AHckZ8NETuCewRGlpKB85meqAitv6tHMaOl4=
Subject: [PATCH 2/3] regulator: Ensure enough delay time for enabling
	regulator
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1288941912.16201.1.camel@mola>
References: <1288941912.16201.1.camel@mola>
Content-Type: text/plain
Date: Fri, 05 Nov 2010 15:26:20 +0800
Message-Id: <1288941980.16201.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integer division will truncate the result, this patch ensures we have
enough delay time for enabling regulator.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5ee67ba..0dd9a57 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1312,9 +1312,10 @@ static int _regulator_enable(struct regulator_dev *rdev)
 			if (ret < 0)
 				return ret;
 
-			if (delay >= 1000)
+			if (delay >= 1000) {
 				mdelay(delay / 1000);
-			else if (delay)
+				udelay(delay % 1000);
+			} else if (delay)
 				udelay(delay);
 
 		} else if (ret < 0) {
-- 
1.7.2



