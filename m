Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1GFHlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 03:41:51 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19060 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1GFHlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 03:41:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 06 Jul 2011 00:41:40 -0700
Message-ID: <4E1411B1.8020102@nvidia.com>
Date: Wed, 6 Jul 2011 16:41:37 +0900
From: Jinyoung Park <jinyoungp@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ko; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: backlight: aat2870_bl: questions about setting max_current
References: <1309935342.6088.5.camel@phoenix>
In-Reply-To: <1309935342.6088.5.camel@phoenix>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Axel

 > 1. Seems the implementation tests wrong value for setting 
aat2870_bl->max_current.
 >     I think you mean:
Right, that's my mean. This is my mistyping bug.

 > 2. Even above issue is fixed, you still cannot differentiate below 2 
cases:
 >          a) if pdata->max_current is not set , or
 >          b) pdata->max_current is set to AAT2870_CURRENT_0_45 ( which 
is also 0 ).
 >     In either case, current implementation will set max_current to 
AAT2870_CURRENT_27_9.
I didn't find it when verifying driver on real device and my self review.
Thanks for your kindly review.

Below is fixed codes. How about this change?
If there is no problem, could you submit this change with first change 
as one patch?
because two changes are related.

diff --git a/drivers/video/backlight/aat2870_bl.c 
b/drivers/video/backlight/aat2870_bl.c
index 4952a61..c0e2ce7 100644
--- a/drivers/video/backlight/aat2870_bl.c
+++ b/drivers/video/backlight/aat2870_bl.c
@@ -44,7 +44,7 @@ static inline int aat2870_brightness(struct 
aat2870_bl_driver_data *aat2870_bl,
         struct backlight_device *bd = aat2870_bl->bd;
         int val;

-       val = brightness * aat2870_bl->max_current;
+       val = brightness * (aat2870_bl->max_current - 1);
         val /= bd->props.max_brightness;

         return val;
diff --git a/include/linux/mfd/aat2870.h b/include/linux/mfd/aat2870.h
index 89212df..f8b7e8e 100644
--- a/include/linux/mfd/aat2870.h
+++ b/include/linux/mfd/aat2870.h
@@ -89,6 +89,7 @@ enum aat2870_id {

  /* Backlight current magnitude (mA) */
  enum aat2870_current {
+       AAT2870_CURRENT_0_00,
         AAT2870_CURRENT_0_45,
         AAT2870_CURRENT_0_90,
         AAT2870_CURRENT_1_80,

Thanks,
Jin.
