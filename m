Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112Ab2GCWr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:47:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61402 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2GCWrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:47:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6761"; a="204903156"
Message-ID: <4FF3769A.3090703@codeaurora.org>
Date: Tue, 03 Jul 2012 15:47:54 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Fix recursive mutex lockdep warning
References: <1341282066-15325-1-git-send-email-sboyd@codeaurora.org> <20120703192652.GH29030@opensource.wolfsonmicro.com> <4FF3514E.6050401@codeaurora.org> <20120703224316.GB11368@opensource.wolfsonmicro.com>
In-Reply-To: <20120703224316.GB11368@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/12 15:43, Mark Brown wrote:
>
>> What do you think about removing the locking in get_voltage? Is that better?
> There's already an unlocked version of get_voltage()?

Yes, I'm suggesting we just use that unlocked version for all of the
code that gets the input voltage.

index ef07b62..4c63336 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -628,7 +628,7 @@ static void drms_uA_update(struct regulator_dev *rdev)
        /* get input voltage */
        input_uV = 0;
        if (rdev->supply)
-               input_uV = regulator_get_voltage(rdev->supply);
+               input_uV = _regulator_get_voltage(rdev->supply->rdev);
        if (input_uV <= 0)
                input_uV = rdev->constraints->input_uV;
        if (input_uV <= 0)
@@ -2582,7 +2582,7 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
        /* get input voltage */
        input_uV = 0;
        if (rdev->supply)
-               input_uV = regulator_get_voltage(rdev->supply);
+               input_uV = _regulator_get_voltage(rdev->supply->rdev);
        if (input_uV <= 0)
                input_uV = rdev->constraints->input_uV;
        if (input_uV <= 0) {


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

