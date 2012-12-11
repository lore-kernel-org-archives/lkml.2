Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab2LKNvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:51:04 -0500
Received: from service87.mimecast.com ([91.220.42.44]:47946 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab2LKNvC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:51:02 -0500
Message-ID: <1355233859.19818.11.camel@hornet>
Subject: Re: [PATCH] regulator: vexpress: Add missing n_voltages setting
From: Pawel Moll <pawel.moll@arm.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 11 Dec 2012 13:50:59 +0000
In-Reply-To: <1355213050.7387.1.camel@phoenix>
References: <1355213050.7387.1.camel@phoenix>
X-Mailer: Evolution 3.6.0-0ubuntu3
Mime-Version: 1.0
X-OriginalArrivalTime: 11 Dec 2012 13:50:59.0900 (UTC) FILETIME=[8D5037C0:01CDD7A6]
X-MC-Unique: 112121113510004201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 08:04 +0000, Axel Lin wrote:
> Otherwise regulator_can_change_voltage() return 0 for this driver.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

We've been here before, haven't we? ;-) So I'll just repeat myself -
this regulator does _not_ have operating points. What I believe should
be fixed is the mentioned function itself, something like the patch
below (untested)...

Pawel

8<--------------------
>From 1cafb644747c276a6c601096b8dc0972d10daac7 Mon Sep 17 00:00:00 2001
From: Pawel Moll <pawel.moll@arm.com>
Date: Tue, 11 Dec 2012 13:44:07 +0000
Subject: [PATCH] regulator: core: Fix regulator_can_change_voltage() for
 continuous case

Function regulator_can_change_voltage() didn't take regulators with
continuous voltage range under consideration. Fixed now.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/regulator/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cd1b201..92768c3 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1886,7 +1886,8 @@ int regulator_can_change_voltage(struct regulator *regulator)
 
 	if (rdev->constraints &&
 	    rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE &&
-	    rdev->desc->n_voltages > 1)
+	    (rdev->desc->n_voltages > 1 ||
+	     rdev->desc->continuous_voltage_range))
 		return 1;
 
 	return 0;
-- 
1.7.10.4



