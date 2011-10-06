Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934691Ab1JFFY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 01:24:28 -0400
Received: from imr3.ericy.com ([198.24.6.13]:54517 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab1JFFY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 01:24:28 -0400
Date: Wed, 5 Oct 2011 22:19:55 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Himanshu Chauhan <hschauhan@nulltrace.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] hwmon class driver registration with a device number
Message-ID: <20111006051955.GA22835@ericsson.com>
References: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
 <1317839407.3983.46.camel@groeck-laptop>
 <20111006040656.GA2125@ubuntu.ubuntu-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111006040656.GA2125@ubuntu.ubuntu-domain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 12:06:59AM -0400, Himanshu Chauhan wrote:
> Hi,
> 
> > I can not comment on the merits of your patch. Unless I am missing
> > something, which may well be since I only spent a couple of minutes on
> > it, other device classes don't seem to provide a similar API, so I don't
> > know if or why it would make sense for hwmon. Maybe a driver which wants
> > to register a character device interface should do so independently of
> > hwmon.
> > 
> 
> The idea here is to sit in the same class directory as of hwmon. Devices
> registered with this interface will have "dev" under, for example,
> /sys/class/hwmon/hwmon0/dev. To do the same inside the driver will be
> a bit more involved than a call.
> 
> In my opinion other classes should also have similar interfaces.
> 
I think you'll have to spend some more time and effort explaining the "what for".

Apparently no other device class needs this functionality so far, yet you
suggest that such an interface should exist for all device classes.
But you do so without explanation, or in other words without use case.

I for my part have no idea what you would use or need this new interface for,
and if there would be other less intrusive means to accomplish the same goal.
And I would want to see really good reasons to make a change like this.

Specifically looking at the hwmon subsystem, you are expected to use the lm-sensors
library to access all hwmon attributes. So I would expect your explanation to include
exactly what you want to accomplish and why, details why you believe that you can not
use the lm-sensors library, why you believe that the current infrastructure
does not provide the means you need to accomplish your goals, and why you
think that the existing infrastructure can not be modified to let you accomplish
what you want to do without such a - from a conceptual perspective - substantial change.

Thanks,
Guenter
