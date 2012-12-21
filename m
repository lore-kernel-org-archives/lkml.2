Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2LUW2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 17:28:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2LUW2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 17:28:46 -0500
Date: Fri, 21 Dec 2012 14:28:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH v2 2/2] backlight: add new lp8788 backlight driver
Message-Id: <20121221142845.c5d6ebda.akpm@linux-foundation.org>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E108D2@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E108D2@DQHE02.ent.ti.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2012 07:55:23 +0000
"Kim, Milo" <Milo.Kim@ti.com> wrote:

> TI LP8788 PMU supports regulators, battery charger, RTC, ADC, backlight driver
> and current sinks.
> This patch enables LP8788 backlight module.
> 
> (Brightness mode)
> The brightness is controlled by PWM input or I2C register.
> All modes are supported in the driver.
> 
> (Platform data)
> Configurable data can be defined in the platform side.
>  name                  : backlight driver name. (default: "lcd-backlight")
>  initial_brightness    : initial value of backlight brightness
>  bl_mode               : brightness control by PWM or lp8788 register
>  dim_mode              : dimming mode selection
>  full_scale            : full scale current setting
>  rise_time             : brightness ramp up step time
>  fall_time             : brightness ramp down step time
>  pwm_pol               : PWM polarity setting when bl_mode is PWM based
>  period_ns             : platform specific PWM period value. unit is nano.

There's also

DEVICE_ATTR(bl_ctl_mode, S_IRUGO, lp8788_get_bl_ctl_mode, NULL);

which isn't documented anywhere?

