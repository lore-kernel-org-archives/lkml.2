Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412Ab1KCPdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 11:33:47 -0400
Received: from imr3.ericy.com ([198.24.6.13]:53504 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122Ab1KCPdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 11:33:46 -0400
Subject: Re: Hardware running hot and without the fan
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Lars =?ISO-8859-1?Q?Nood=E9n?= <lars.nooden@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Henrik Rydberg <rydberg@euromail.se>
In-Reply-To: <4EB2B0FD.309@gmail.com>
References: <4EB1108F.6070009@gmail.com>
	 <20111103020301.GA22333@ericsson.com> <4EB250FD.3070000@gmail.com>
	 <20111103134902.GA26121@ericsson.com>  <4EB2A46B.8080600@gmail.com>
	 <1320332801.2309.60.camel@groeck-laptop>  <4EB2B0FD.309@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Thu, 3 Nov 2011 08:32:02 -0700
Message-ID: <1320334322.2309.68.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 11:19 -0400, Lars Noodén wrote:
> On 11/03/2011 05:06 PM, Guenter Roeck wrote:
> > On Thu, 2011-11-03 at 10:25 -0400, Lars Noodén wrote:
> [snip]
> >> The one machine reports one fan and the other two fans.  I haven't found
> >> a way to set the fan speed manually.  The output from sensors
> >> is
> >>  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/881593/comments/44
> >> and here
> >>  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/881593/comments/47
> > 
> > Do the fans actually turn, or is the output bogus ?
> 
> The output is bogus, the fans are not turning.  On #47 there above, I
> think the temperatures might be inaccurate, too.  Since they'll go up
> and down as much as 8 degrees in a few seconds.
> 
Maybe 2000 really reflects 0. Not sure about the temperatures - I think
especially the CPU temperature can change pretty fast. Or maybe the
sensors are just not very accurate.

> > You should be able to set the fan speed by writing into the fanX_input
> > and/or fanX_output sysfs attributes. You find those
> > in /sys/class/hwmon/hwmon0/device (assuming there is only one hwmon
> > device).
> 
> I can set the fan speed manually.  e.g.:
> 
>  echo 3500 > /sys/class/hwmon/hwmon0/device/fan1_output
> 
> That helps some.
> 
If you can do that, you should be able to set up fancontrol to
automatically control fan speed based on system temperatures.

There is another sysfs attribute - fanX_manual. I don't find driver
documentation, so I have no idea what it is doing. The name indicates
that it might set manual vs. automatic fan control. What is it set to in
your system ? From the code, looks like it should be 0 or 1. Try to
toggle it and see what happens - after all, it can not get worse ;).

Guenter


