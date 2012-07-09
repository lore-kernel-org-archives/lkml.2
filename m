Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab2GIHqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 03:46:35 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1538 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2GIHqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 03:46:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Jul 2012 00:42:53 -0700
Message-ID: <4FFA8CCC.8060000@nvidia.com>
Date: Mon, 9 Jul 2012 16:48:28 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH V2 2/3] pwm_backlight: use power sequences
References: <1341814105-20690-1-git-send-email-acourbot@nvidia.com> <1341814105-20690-3-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1341814105-20690-3-git-send-email-acourbot@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I just noticed a mistake in this patch I made while merging 
another one. The following also needs to be changed, otherwise the 
power-on sequence will never be executed:

diff --git a/drivers/video/backlight/pwm_bl.c 
b/drivers/video/backlight/pwm_bl.c
index 1a38953..4546d23 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -65,7 +98,7 @@ static int pwm_backlight_update_status(struct 
backlight_device *bl)
                 duty_cycle = pb->lth_brightness +
                      (duty_cycle * (pb->period - pb->lth_brightness) / 
max);
                 pwm_config(pb->pwm, duty_cycle, pb->period);
-               pwm_enable(pb->pwm);
+               pwm_backlight_on(bl);
         }


Apologies for the inconvenience.

Alex.

