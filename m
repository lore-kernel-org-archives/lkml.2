Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608Ab0LUGFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 01:05:20 -0500
Received: from mail12.space2u.com ([194.237.215.104]:42252 "EHLO
	mail12.space2u.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab0LUGFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 01:05:19 -0500
Subject: Re: [lm-sensors] [PATCH 1/2 V3] applesmc: Use PnP rather than
 hardcoding resources and devices
From: Mikael =?ISO-8859-1?Q?Str=F6m?= <mikael@sesamiq.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Henrik Rydberg <rydberg@euromail.se>, Julien BLACHE <jb@jblache.org>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101220140032.GA23257@srcf.ucam.org>
References: <20101217221618.GA13207@ericsson.com>
	 <1292624661-32474-1-git-send-email-mjg@redhat.com>
	 <20101218042320.GA14104@ericsson.com>
	 <20101218093719.GA1493@polaris.bitmath.org>
	 <20101218110954.7a2ca190@endymion.delvare>
	 <20101218103139.GA1668@polaris.bitmath.org>
	 <878vzngvyn.fsf@sonic.technologeek.org>
	 <20101218115742.GA2063@polaris.bitmath.org>
	 <1292852674.2118.10.camel@mike-laptop>
	 <20101220140032.GA23257@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 14:04:40 +0800
Message-ID: <1292911480.2316.43.camel@mike-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 14:00 +0000, Matthew Garrett wrote:
> On Mon, Dec 20, 2010 at 09:44:34PM +0800, Mikael Ström wrote:
> > Hi,
> > 
> > I know nothing about the background to the mail below, but if it's of
> > any help, macfanctld uses the following hardwired paths,
> > 
> > reading:
> > 
> > /sys/devices/platform/applesmc.768/temp<n>_input
> > 
> > and writing:
> > 
> > /sys/devices/platform/applesmc.768/fan1_min
> > /sys/devices/platform/applesmc.768/fan2_min
> > /sys/devices/platform/applesmc.768/fan1_manual
> > /sys/devices/platform/applesmc.768/fan2_manual
> > 
> > If any of those are to be broken, please advice in advance so i can
> > update the source before you break it, avoiding that the users fry their
> > MacBooks.
> 
> Yes, it's very broken. Walk /sys/class/hwmon and look for an entry with 
> an appropriate name, don't hardcode device paths. But given the 
> breakage, it might be easier to just keep the platform device for now. 
> I'll redo the patch with that in mind.
> 
>From the other mail conversation, i realize that there is much needed
changes on the way, in particular efi support. A kernel based fan
control would be great as well. Until we get one, i keep macfancld alive
and will update it to use /sys/class/hwmon/, if that is the better way
to do it. 

Before i start to work on that, please confirm that i got this right:

In /sys/class/hwmon/hwmon<0..n>/device, locate fan<1..2>_* for
controlling the fan(s).

In /sys/class/hwmon/hwmon<0..n>/device, locate temp<1..n>_* for
enumerating and reading the temp sensors.

***

Finally, i would like to comment on the issue of fan controls for
MacBooks in general: This issues is not valid only under Linux. In fact,
most Unibody (Aluminum) MacBook users i know, have downloaded some form
of fan control for OSX to keep their laptops reasonable cold. Perhaps
this stems from that Aluminum leads heat much better so the user
"experience" that his laptop is hotter than a comparable plastic dito.
Never the less, the need is there, and users do want a better fan
control. So to make this right, we should probably have a similar fan
control mechanism in the kernel as we have in macfanctld. However,
different versions of MacBooks turn out to behave very differently, so
there is probably a need for some kind of configuration per model and/or
user configurable settings.

If there is anything more i can do to help, just let me know.

Regards,
Mike


