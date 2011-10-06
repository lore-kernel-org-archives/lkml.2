Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab1JFPRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 11:17:10 -0400
Received: from imr3.ericy.com ([198.24.6.13]:57550 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab1JFPRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 11:17:09 -0400
Subject: Re: [lm-sensors] [PATCH] hwmon class driver registration with a
 device number
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jean Delvare <khali@linux-fr.org>
CC: Himanshu Chauhan <hschauhan@nulltrace.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20111006094302.71ea4dfd@endymion.delvare>
References: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
	 <1317839407.3983.46.camel@groeck-laptop>
	 <20111006040656.GA2125@ubuntu.ubuntu-domain>
	 <20111006051955.GA22835@ericsson.com>
	 <20111006094302.71ea4dfd@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Thu, 6 Oct 2011 08:15:26 -0700
Message-ID: <1317914126.3983.55.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 03:43 -0400, Jean Delvare wrote:
> I am purposely removing kernelnewbies from the CC list, as it seems
> quite irrelevant for this discussion.
> 
> On Wed, 5 Oct 2011 22:19:55 -0700, Guenter Roeck wrote:
> > On Thu, Oct 06, 2011 at 12:06:59AM -0400, Himanshu Chauhan wrote:
> > > Hi,
> > > 
> > > > I can not comment on the merits of your patch. Unless I am missing
> > > > something, which may well be since I only spent a couple of minutes on
> > > > it, other device classes don't seem to provide a similar API, so I don't
> > > > know if or why it would make sense for hwmon. Maybe a driver which wants
> > > > to register a character device interface should do so independently of
> > > > hwmon.
> > > > 
> > > 
> > > The idea here is to sit in the same class directory as of hwmon. Devices
> > > registered with this interface will have "dev" under, for example,
> > > /sys/class/hwmon/hwmon0/dev. To do the same inside the driver will be
> > > a bit more involved than a call.
> > > 
> > > In my opinion other classes should also have similar interfaces.
> > > 
> > I think you'll have to spend some more time and effort explaining the "what for".
> > 
> > Apparently no other device class needs this functionality so far, yet you
> > suggest that such an interface should exist for all device classes.
> 
> Actually a lot of class devices do have a device node:
> $ ls -1 /sys/class/*/*/dev | wc -l
> 252
> This includes block, drm, dvb, input, msr, sound and tty class devices,
> to name just a few. But this isn't the problem. All these are

I meant instances where the major/minor device number is passed to the
class registration function.

Having said that, I realize there are instances where the _minor_ device
number is passed to the class registration function (eg for misc
devices). In that case, though, misc_register() checks if the asked for
minor device already exists, and retains the option to generate a
dynamic minor device. This is different here, where the proposal is to
pass both major and minor device number to the registration function.

Maybe there are instances where both major and minor device number are
passed; as I mentioned before, I did not spend that much time on it. But
you are right - that isn't the point anyway.

Guenter


