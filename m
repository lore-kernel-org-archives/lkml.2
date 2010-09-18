Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab0IRStO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 14:49:14 -0400
Received: from kroah.org ([198.145.64.141]:38978 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab0IRSsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 14:48:40 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:46:21 2010
Message-Id: <20100918184621.798863054@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:45:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: [10/11] apm_power: Add missing break statement
In-Reply-To: <20100918184651.GA14224@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Vorontsov <cbouatmailru@gmail.com>

commit 1d220334d6a8a711149234dc5f98d34ae02226b8 upstream.

The missing break statement causes wrong capacity calculation for
batteries that report energy.

Reported-by: d binderman <dcb314@hotmail.com>
Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/power/apm_power.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/power/apm_power.c
+++ b/drivers/power/apm_power.c
@@ -233,6 +233,7 @@ static int calculate_capacity(enum apm_s
 		empty_design_prop = POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN;
 		now_prop = POWER_SUPPLY_PROP_ENERGY_NOW;
 		avg_prop = POWER_SUPPLY_PROP_ENERGY_AVG;
+		break;
 	case SOURCE_VOLTAGE:
 		full_prop = POWER_SUPPLY_PROP_VOLTAGE_MAX;
 		empty_prop = POWER_SUPPLY_PROP_VOLTAGE_MIN;


