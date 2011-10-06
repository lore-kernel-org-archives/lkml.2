Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab1JFPUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 11:20:37 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48404 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758384Ab1JFPUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 11:20:36 -0400
Date: Thu, 6 Oct 2011 20:42:32 +0530
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon class driver registration with a
 device number
Message-ID: <20111006151232.GA3267@ubuntu.ubuntu-domain>
References: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
 <1317839407.3983.46.camel@groeck-laptop>
 <20111006040656.GA2125@ubuntu.ubuntu-domain>
 <20111006051955.GA22835@ericsson.com>
 <20111006094302.71ea4dfd@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111006094302.71ea4dfd@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 09:43:02AM +0200, Jean Delvare wrote:
>

Thanks Jean for summing up the questions :)
 
> I again agree. Which means that Himanshu is still 3 steps away from
> getting his patch accepted:
> * Explaining why the current sysfs interface is insufficient and can't
>   be fixed.

AFAIK, the current sysfs interface is to read standard attributes from
the device. My reasoning is:

1. This will give hwmon devices to have their "dev" in their sysfs folder
   as like other classes and in turn be visible in /dev by mdev or udev.

2. Implementing IOCTL if required. I know that kernel hackers believe
   they are "backdoors" and "can't be done right" but sometimes there
   isn't any get away with them. I don't know when their support will
   be completely removed. Rather, I see that instead of deprecation,
   new IOCTL vectors like compat_ioctl have been introduced.

> * Getting official device node numbers registered for hwmon use.

Jean, as long as drivers get major device numbers on the fly, I don't
think this is a requirement. Isn't it?

> * Defining an API for these device nodes.
My idea is just this:
1. Get a major number from kernel on the fly.
2. During probing, for each device, call "hwmon_device_register_numbered"
   and let mdev create a /dev node for it. I don't say that this interface
   be imposed on drivers. If they want they can still call "hwmon_device_register"
   if they don't want to implement standard ioctl, read, write calls.
 
> Before then, there's no point in resending this patch, it will be
> rejected.
> 

Thanks for reviewing. These are my thoughts. If you guys think the reasoning
isn't strong enough to get this in mainline, I am happy to accept that :)
At least I know what can get rejected for sure and I am happy to build a
stack of rejected patches for that. :)

-Himanshu
