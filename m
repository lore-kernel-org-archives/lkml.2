Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab1C3QO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:14:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64815 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688Ab1C3QO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:14:27 -0400
Date: Wed, 30 Mar 2011 17:14:19 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: Re: [PATCH] msm: watchdog: support watchdog on 8x60 and 8960
Message-ID: <20110330161419.GB28252@pulham.picochip.com>
References: <1301105894-22835-1-git-send-email-johlstei@codeaurora.org>
 <1301426560.4049.0.camel@m0nster>
 <4D92B43B.5050101@codeaurora.org>
 <1301501006.5346.2.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301501006.5346.2.camel@m0nster>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 09:03:26AM -0700, Daniel Walker wrote:
> On Tue, 2011-03-29 at 21:40 -0700, Jeff Ohlstein wrote:
> > Daniel Walker wrote:
> > > Are you saying this is mostly a debugging facility ? The interrupts off
> > > thing I can see as just debugging, but I don't understand the bus
> > > lockups part.
> > >   
> > 
> > It isn't just a debugging facility. It is still beneficial to the end user
> > in that it restarts the system if there is a bus lockup or a faulty 
> > interrupt
> > handler in a rarely used codepath. This is better than the alternative 
> > of draining
> > the battery and turning off. We want this to be turned on independent of 
> > what userspace
> > one is using, unless they explicitly turn it off themselves.
> 
> It doesn't sound too different that all the other watchdogs in
> drivers/watchdog/ .. Your just detecting lockups right?

There are some watchdogs in there such as 
drivers/watchdog/at91sam9_wdt.c that can't be stopped once enabled so 
the driver sets up a soft timer in the kernel that kicks the watchdog to 
prevent the system rebooting.

With this approach you could have the watchdog always enabled and being 
kicked even if the userspace daemon wasn't running, but with the 
flexibility of kicking it from userspace if you wanted.

Jamie
