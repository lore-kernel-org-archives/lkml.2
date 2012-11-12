Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab2KLEn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 23:43:28 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45294 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab2KLEn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 23:43:26 -0500
Message-ID: <50A07E8B.20902@linaro.org>
Date: Mon, 12 Nov 2012 10:13:55 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, philipspatches@gmail.com, patches@linaro.org
Subject: Re: [PATCH] regulator: core: Update regulator_is_supported_voltage
 for fixed voltages
References: <1352458309-18141-1-git-send-email-tushar.behera@linaro.org> <20121109170918.GW23807@opensource.wolfsonmicro.com>
In-Reply-To: <20121109170918.GW23807@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 10:39 PM, Mark Brown wrote:
> On Fri, Nov 09, 2012 at 04:21:49PM +0530, Tushar Behera wrote:
> 
>> In case of fixed regulators for which voltage cannot be changed,
>> regulator_is_supported_voltage should return success only if the
>> min_uV and max_uV parameters are same and it is equal to the current
>> voltage of the regulator.
> 
> This makes no sense to me at all.  The caller is asking if it's possible
> to set the voltage between the minimum and maximum values, any voltage
> in that range should be OK.  Your patch makes the function massively
> less useful.
> 

Ok.

In that case, we should modify the test condition as following.
Currently it passes success when the regulator voltage is less than both
min_uV and max_uV. If ok, I will send another patch for this.

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1a35251..e90e5c3 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1974,7 +1974,7 @@ int regulator_is_supported_voltage(struct
regulator *regulator,
        if (!(rdev->constraints->valid_ops_mask &
REGULATOR_CHANGE_VOLTAGE)) {
                ret = regulator_get_voltage(regulator);
                if (ret >= 0)
-                       return (min_uV >= ret && ret <= max_uV);
+                       return (ret >= min_uV && ret <= max_uV);
                else
                        return ret;
        }


-- 
Tushar Behera
