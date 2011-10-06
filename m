Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab1JFHnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 03:43:17 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:7143 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab1JFHnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 03:43:16 -0400
Date: Thu, 6 Oct 2011 09:43:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Himanshu Chauhan <hschauhan@nulltrace.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon class driver registration with a 
 device number
Message-ID: <20111006094302.71ea4dfd@endymion.delvare>
In-Reply-To: <20111006051955.GA22835@ericsson.com>
References: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
	<1317839407.3983.46.camel@groeck-laptop>
	<20111006040656.GA2125@ubuntu.ubuntu-domain>
	<20111006051955.GA22835@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am purposely removing kernelnewbies from the CC list, as it seems
quite irrelevant for this discussion.

On Wed, 5 Oct 2011 22:19:55 -0700, Guenter Roeck wrote:
> On Thu, Oct 06, 2011 at 12:06:59AM -0400, Himanshu Chauhan wrote:
> > Hi,
> > 
> > > I can not comment on the merits of your patch. Unless I am missing
> > > something, which may well be since I only spent a couple of minutes on
> > > it, other device classes don't seem to provide a similar API, so I don't
> > > know if or why it would make sense for hwmon. Maybe a driver which wants
> > > to register a character device interface should do so independently of
> > > hwmon.
> > > 
> > 
> > The idea here is to sit in the same class directory as of hwmon. Devices
> > registered with this interface will have "dev" under, for example,
> > /sys/class/hwmon/hwmon0/dev. To do the same inside the driver will be
> > a bit more involved than a call.
> > 
> > In my opinion other classes should also have similar interfaces.
> > 
> I think you'll have to spend some more time and effort explaining the "what for".
> 
> Apparently no other device class needs this functionality so far, yet you
> suggest that such an interface should exist for all device classes.

Actually a lot of class devices do have a device node:
$ ls -1 /sys/class/*/*/dev | wc -l
252
This includes block, drm, dvb, input, msr, sound and tty class devices,
to name just a few. But this isn't the problem. All these are
documented in Documentation/devices.txt, and have a properly defined
API. There is no such thing for hwmon devices at this point.

> But you do so without explanation, or in other words without use case.

This is indeed the key point. Creating a device node is pointless
without a standard API to make use of it. So Himanshu will have to
document that first.

> I for my part have no idea what you would use or need this new interface for,
> and if there would be other less intrusive means to accomplish the same goal.
> And I would want to see really good reasons to make a change like this.

Another good point.

> Specifically looking at the hwmon subsystem, you are expected to use the lm-sensors
> library to access all hwmon attributes. So I would expect your explanation to include
> exactly what you want to accomplish and why, details why you believe that you can not
> use the lm-sensors library, why you believe that the current infrastructure
> does not provide the means you need to accomplish your goals, and why you
> think that the existing infrastructure can not be modified to let you accomplish
> what you want to do without such a - from a conceptual perspective - substantial change.

I again agree. Which means that Himanshu is still 3 steps away from
getting his patch accepted:
* Explaining why the current sysfs interface is insufficient and can't
  be fixed.
* Getting official device node numbers registered for hwmon use.
* Defining an API for these device nodes.

Before then, there's no point in resending this patch, it will be
rejected.

-- 
Jean Delvare
