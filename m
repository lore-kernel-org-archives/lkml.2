Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119Ab1JFTKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:10:18 -0400
Received: from imr4.ericy.com ([198.24.6.9]:48247 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302Ab1JFTKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:10:17 -0400
Date: Thu, 6 Oct 2011 12:07:52 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Greg KH <greg@kroah.com>
CC: Himanshu Chauhan <hschauhan@nulltrace.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>
Subject: Re: [lm-sensors] [PATCH] hwmon class driver registration with a
 device number
Message-ID: <20111006190752.GA28455@ericsson.com>
References: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
 <20111005193359.GB26664@kroah.com>
 <20111006041011.GB2125@ubuntu.ubuntu-domain>
 <20111006182500.GA18607@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111006182500.GA18607@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 02:25:00PM -0400, Greg KH wrote:
> On Thu, Oct 06, 2011 at 09:40:11AM +0530, Himanshu Chauhan wrote:
> > Hi Greg,
> > 
> > > 
> > > How do you later remove a device created with this new interface?  As it
> > > is, I think the existing calls will fail, right?
> > > 
> > If I have not missed out anything from hwmon_device_unregister(), it shouldn't
> > fail. Why did you point that out?
> 
> If you create a device with a call to device_create() with a dev_t set,
> it is usually cleaned up with a call to device_destroy(), but you are
> right, a simple call to device_unregister() will still work properly.
> 
> So nevermind, sorry for the noise.
> 
Not entirely noise. Since the new registration call is not exported in the patch,
any code using it won't be compilable as module, which in turn means
that hwmon_device_unregister() was never called.
So while we know that it _should_ work, we also know that it was not tested.

> What you do need to determine is if this is a device node you really
> want to be creating in this manner, as it is a new user/kernel API,
> right?
> 
And why, and what for.

Guenter
