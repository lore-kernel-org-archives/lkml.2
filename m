Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab0IGUww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 16:52:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62785 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab0IGUwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 16:52:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Ipvt8cQCSFx+/UN/VSZOXABv7mEyjGKW8bt9PGTPyVku8BY/ZP4WIOAFCpO9eZQOcU
         OlMMoEubsn0+m9yPpt+m9zttg5TJaKxyCcO41CD/I0mSH8O1VFYUxjzIxq/DJpQYkQfO
         AIpg2JhOGUH998h+u8JPCz113LumZEZ/v8stM=
Date: Wed, 8 Sep 2010 00:28:28 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: d binderman <dcb314@hotmail.com>, dwmw2@infradead.org
Subject: [PATCH] apm_power: Add missing break statement
Message-ID: <20100907202828.GA14143@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The missing break statement causes wrong capacity calculation for
batteries that report energy.

Reported-by: d binderman <dcb314@hotmail.com>
Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---

Applied to battery-2.6.36.git.

 drivers/power/apm_power.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/apm_power.c b/drivers/power/apm_power.c
index 936bae5..dc628cb 100644
--- a/drivers/power/apm_power.c
+++ b/drivers/power/apm_power.c
@@ -233,6 +233,7 @@ static int calculate_capacity(enum apm_source source)
 		empty_design_prop = POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN;
 		now_prop = POWER_SUPPLY_PROP_ENERGY_NOW;
 		avg_prop = POWER_SUPPLY_PROP_ENERGY_AVG;
+		break;
 	case SOURCE_VOLTAGE:
 		full_prop = POWER_SUPPLY_PROP_VOLTAGE_MAX;
 		empty_prop = POWER_SUPPLY_PROP_VOLTAGE_MIN;
-- 
1.7.0.5
