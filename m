Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab0JVQTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:19:31 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:50120 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab0JVQTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:19:30 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4CC1BAEE.3030708@cam.ac.uk>
Date: Fri, 22 Oct 2010 17:25:18 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Lightning/1.0b3pre Thunderbird/3.1.5
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
CC: eric.piel@tremplin-utc.net, khali@linux-fr.org, guenter.roeck@ericsson.com,
        lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] hwmon: lis3: Short explanations of platform data
 fields
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com> <1287748654-2626-12-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1287748654-2626-12-git-send-email-samu.p.onkalo@nokia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/10 12:57, Samu Onkalo wrote:
> Short documentation at kernel doc format.
> 
Please check the use of tabs etc in the alignment of the documentation.
It might work out right, but looks a bit random currently.

Couple of typos.  Otherwise looks fine to me, but I'll only give
a reviewed by on this as I really don't know the devices well enough!
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
> ---
>  include/linux/lis3lv02d.h |   41 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 41 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
> index c949612..da294cd 100644
> --- a/include/linux/lis3lv02d.h
> +++ b/include/linux/lis3lv02d.h
> @@ -1,6 +1,47 @@
>  #ifndef __LIS3LV02D_H_
>  #define __LIS3LV02D_H_
>  
> +/**
> + * struct lis3lv02d_platform_data - lis3 chip family platform data
> + * @click_flags:       Click detection unit configuration
> + * @click_thresh_x:    Click detection unit x axis treshold
threshold
> + * @click_thresh_y:    Click detection unit y axis treshold
> + * @click_thresh_z:    Click detection unit z axis treshold
> + * @click_time_limit:  Click detection unit time parameter
> + * @click_latency:     Click detection unit latency parameter
> + * @click_window:      Click detection unit window parameter
> + * @irq_cfg:	       On chip irq configuration (click / data available / wu)
wu isn't a terribly helpful acronym, please put it in long hand.  iirc kernel
doc lets you use multiple lines for parameter descriptions...
> + * @irq_flags1:	       Additional irq triggering flags for irq channel 0
> + * @irq_flags2:	       Additional irq triggering flags for irq channel 1
> + * @duration1:	       Wake up unit 1 duration parameter
> + * @duration2:	       Wake up unit 2 duration parameter
> + * @wakeup_flags:      Wakeup unit 1 flags
> + * @wakeup_thresh:     Wakeup unit 1 threshold value
> + * @wakeup_flags2:     Wakeup unit 2 flags
> + * @wakeup_thresh2:    Wakeup unit 2 threshold value
> + * @hipass_ctrl:       Hi-pass filter control
High-pass
> + * @axis_x:	       Remap parameter for x-axis
> + * @axis_y:	       Remap parameter for y-axis
> + * @axis_z:	       Remap parameter for z-axis
> + * @driver_features:   Enable bits for different features. Disabled by default
> + * @default_rate:      Default sampling rate. 0 means reset default
> + * @setup_resources:   Interrupt line setup call back function
> + * @release_resources: Interrupt line release call back function
> + * @st_min_limits[3]:  Selftest acceptance minimum values
> + * @st_max_limits[3]:  Selftest accepratnce maximum values
acceptance
> + * @irq2:	       Irq line 2 number
> + *
> + * Platform data is used to setup the sensor chip. Meaning of the different
> + * chip features can be found from the data sheet. Currently the data is used
> + * only for the 8 bit device. The 8 bit device has two wake up / free fall
> + * detection units and click detection unit. There are plenty of ways to
> + * configure the chip which makes is quite impossible to explain meaning of the
> + * fields here. Behaviour of the detection blocks varies heavily depending
> + * on the configuration. Irq_flags can be used to enable interrupt detection
> + * on the both edges. With proper chip configuration this produces interrupt
> + * when some trigger starts and when it goes away.
> + */
> +
>  struct lis3lv02d_platform_data {
>  	/* please note: the 'click' feature is only supported for
>  	 * LIS[32]02DL variants of the chip and will be ignored for

