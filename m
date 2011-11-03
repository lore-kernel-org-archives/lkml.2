Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341Ab1KCPIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 11:08:38 -0400
Received: from imr4.ericy.com ([198.24.6.9]:48206 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933Ab1KCPIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 11:08:36 -0400
Subject: Re: Hardware running hot and without the fan
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Lars =?ISO-8859-1?Q?Nood=E9n?= <lars.nooden@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Henrik Rydberg <rydberg@euromail.se>
In-Reply-To: <4EB2A46B.8080600@gmail.com>
References: <4EB1108F.6070009@gmail.com>
	 <20111103020301.GA22333@ericsson.com> <4EB250FD.3070000@gmail.com>
	 <20111103134902.GA26121@ericsson.com>  <4EB2A46B.8080600@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Thu, 3 Nov 2011 08:06:41 -0700
Message-ID: <1320332801.2309.60.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 10:25 -0400, Lars Noodén wrote:
> On 11/03/2011 03:49 PM, Guenter Roeck wrote:
> > On Thu, Nov 03, 2011 at 04:29:49AM -0400, Lars Noodén wrote:
> >> On 11/03/2011 04:03 AM, Guenter Roeck wrote:
> >>> From LKML:
> >>>
> >>> On Wed, Nov 02, 2011 at 05:42:39AM -0400, Lars Noodén wrote:
> >>>> There seem to be two problems here, one is that the hardware is 
> >>>> getting WAY too hot, another is that the fan is not turning on when
> >>>> the hardware gets too hot.
> >>>>
> >>>> $ uname -a Linux xubuntu 3.1.0-999-generic #201110270406 SMP Thu 
> >>>> Oct 27 08:07:41 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux
> >>>>
> >>>> I've reported the problem to Ubuntu 
> >>>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/881593 and the
> >>>> suggestion there was to report it upstream.
> >>>>
> >>>> On the notebook computer, parts become very hot to the touch while 
> >>>> running Ubuntu, but the fan does not run even after it gets hot. 
> >>>> When I boot back to OS X, the fan kicks in and runs until the 
> >>>> computer returns to being cool to the touch.  Similar for the 
> >>>> desktop, though I must follow the temperature with 
> >>>> /usr/bin/sensors.
> >>>>
> >>>> The notebook is a MacBookPro8,2 and the desktop is a Macmini3,1
> >>>>
> >>>> What metrics do I need to collect to help fix the problem?  I've 
> >>>> already reported the problem to Ubuntu[2] and the recommendation 
> >>>> was to try reporting upstream.
> >>>>
> >>>> Please CC me in the replies. /Lars
> >>>>
> >>>> [1] http://kernel.ubuntu.com/~kernel-ppa/mainline/daily/current/
> >>>>
> >>>> [2] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/881593
> >>>
> >>> I see applesmc: : read arg fail in the dmesg log. No idea what that 
> >>> means. Maybe the driver maintainer or someone else on the lm-sensors
> >>>  mailing list can help.
> >>>
> >>> Not sure I understand your comment about having to follow the output
> >>>  of the sensors command. Can you clarify ?
> >>
> >> That's to track the temperature manually.
> >>
> >>> Also, do you get any output from the sensors command on the notebook?
> >>> Thanks, Guenter
> >>
> >> Yes.  It claims to have 24 temperature sensors.
> >>
> > Does it report any fans ? If it does, can you try setting the fan speed ?
> 
> The one machine reports one fan and the other two fans.  I haven't found
> a way to set the fan speed manually.  The output from sensors
> is
>  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/881593/comments/44
> and here
>  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/881593/comments/47
> 

Do the fans actually turn, or is the output bogus ?

You should be able to set the fan speed by writing into the fanX_input
and/or fanX_output sysfs attributes. You find those
in /sys/class/hwmon/hwmon0/device (assuming there is only one hwmon
device).

Thanks,
Guenter


