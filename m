Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097Ab1JGPrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 11:47:36 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36688 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760007Ab1JGPre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 11:47:34 -0400
X-Sasl-enc: ZL7JXZPTvouc26c0snjNTB2A/63jRbP2hX0lCQeXjFvc 1318002453
Date: Fri, 7 Oct 2011 08:46:27 -0700
From: Greg KH <greg@kroah.com>
To: Himanshu Chauhan <hschauhan@nulltrace.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>
Subject: Re: [lm-sensors] [PATCH] hwmon class driver registration with a
 device number
Message-ID: <20111007154627.GA941@kroah.com>
References: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
 <20111005193359.GB26664@kroah.com>
 <20111006041011.GB2125@ubuntu.ubuntu-domain>
 <20111006182500.GA18607@kroah.com>
 <20111006190752.GA28455@ericsson.com>
 <20111007064240.GA2944@ubuntu.ubuntu-domain>
 <20111007065237.GA27805@kroah.com>
 <20111007095621.GB2944@ubuntu.ubuntu-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111007095621.GB2944@ubuntu.ubuntu-domain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 03:26:21PM +0530, Himanshu Chauhan wrote:
> On Thu, Oct 06, 2011 at 11:52:37PM -0700, Greg KH wrote:
> > On Fri, Oct 07, 2011 at 12:12:40PM +0530, Himanshu Chauhan wrote:
> > > On Thu, Oct 06, 2011 at 12:07:52PM -0700, Guenter Roeck wrote:
> > > > And why, and what for.
> > > 
> > > The initial idea of posting to kernelnewbies was to get a hint on how
> > > the patch would be taken as. I wanted to know if developers will like
> > > the idea behind it or not. I guess, Guenter is not convinced with
> > > any of my reasoning. I am willing to clean it up further only if
> > > I get a positive hint. But it doesn't seem to be going anywhere.
> > > 
> > > Thanks Guenter, Alan, and Greg for taking your time and reviewing it.
> > > 
> > > Greg: To answer your last question, if this was taken positively, I
> > > was thinking of having functionality similar to misc device registration.
> > 
> > But why?  What is that device node going to be used for?  Who would be
> > using it in userspace and where would it be tied into in the kernel?
> > 
> The device node, as I said earlier, can be used for doing IOCTLS.

It can?  Which ones?  New ones you want to propose?  If so, why use an
ioctl?

> In user space, applications that manage and monitor system environment
> will need to use this interface for querying the sensor's location,
> for example. In side the kernel, the driver that is driving the
> particular hardware sensor can register a char interface for all this
> and then register with hwmon with the same major/minor for usual sysfs
> export of data.

So you are creating a new user/kernel api here, right?  If so, you need
to document it in Documentation/API and we need to be able to approve
that BEFORE we could ever accept the creation of new device nodes like
this, that at the moment, do not do anything.

In other words, you need to prove you need a new ioctl interface before
you can get a patch accepted that implements this.

greg k-h
