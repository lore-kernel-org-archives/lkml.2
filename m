Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161163Ab2CORD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:03:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38908 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161152Ab2CORDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:03:55 -0400
Date: Thu, 15 Mar 2012 21:03:50 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>
Subject: Re: [PATCH] power_supply: charger-manager: Clean up for better
 readability
Message-ID: <20120315170350.GB11441@oksana.dev.rtsoft.ru>
References: <1326344195.7311.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1326344195.7311.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 12:56:35PM +0800, Axel Lin wrote:
> This patch includes below changes:
> 
> * Some code change for better readability.
> * Current code in probe already ensures desc->charger_regulators is not NULL.
>   No need to check if it is NULL or not before calling regulator_bulk_free().
> * Use dev_get_drvdata() in cm_suspend_prepare() and cm_suspend_complete()
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---

Applied, thanks a lot!


FWIW, I also applied the following patch:

commit f304f0a31442f4c8b98208acedc3da2f6c60a771
Author: Anton Vorontsov <anton.vorontsov@linaro.org>
Date:   Thu Mar 15 21:01:28 2012 +0400

    charger-manager: Simplify charger_get_property(), get rid of a warning
    
    This patch fixes the following warning and makes the code a little
    bit more simpler:
    
      CC      drivers/power/charger-manager.o
    charger-manager.c: In function 'charger_get_property':
    charger-manager.c:429:15: warning: 'i' may be used uninitialized in this function [-Wuninitialized]
    
    Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index e610e6b..9eca9f1 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -399,7 +399,8 @@ static int charger_get_property(struct power_supply *psy,
 	struct charger_manager *cm = container_of(psy,
 			struct charger_manager, charger_psy);
 	struct charger_desc *desc = cm->desc;
-	int i, ret = 0, uV;
+	int ret = 0;
+	int uV;
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
@@ -425,8 +426,7 @@ static int charger_get_property(struct power_supply *psy,
 			val->intval = 0;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		ret = get_batt_uV(cm, &i);
-		val->intval = i;
+		ret = get_batt_uV(cm, &val->intval);
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
