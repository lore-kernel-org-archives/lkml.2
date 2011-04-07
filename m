Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1DGNUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:20:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45701 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab1DGNUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:20:51 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=XYJHFtupD_QA:10 a=YIYGEDvFEgsA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=QNmi9Sp72UPk8Su8vhAA:9 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 7 Apr 2011 09:20:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Possible to software trigger an interrupt?
Message-ID: <20110407132048.GA7257@home.goodmis.org>
References: <4D989A8A.3050700@cam.ac.uk>
 <4D98A185.1080704@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D98A185.1080704@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 03, 2011 at 05:34:13PM +0100, Jonathan Cameron wrote:
> On 04/03/11 17:04, Jonathan Cameron wrote:
> > Hi,
> > 
> > Having produced a proof of concept for using gpio chips
> > to handle the triggers in IIO I am looking at converting
> > over our sysfs trigger.  This trigger is used to initialize
> > capture on devices in a similar way to dataready interrupts.
> > The key point is we want to handle this in the same way within
> > drivers as the hardware event triggers. 
> > 
> > It is a very useful tool.  So the upshot is, what is the best
> > way to handle causing an interrupt to occur from userspace?
> > 
> > Any pointers on how to do this would be most welcome.
> 
> For what it is worth, the incredibly dumb approach of just
> calling handle_nested_irq seems to 'work'.   I dread to think
> what that might be quietly breaking though...

I think you are fine in calling that. It's made to be called from a
threaded context. But if you are testing code that will someday be
called in an interrupt context, it may not catch everything you need.

For example, a mutex is allowed to be called from a threaded context,
but not from a hard irq one. There may be other subtle locking issues as
well. These could be caught with lockdep, but only when the code is
really been executed from hard irq context.

-- Steve


> 
> My understanding of some of this code is still rather limited
> I'm afraid!
