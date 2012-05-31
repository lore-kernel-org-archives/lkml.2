Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab2EaHhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:37:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:55319 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab2EaHhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 03:37:01 -0400
Date: Thu, 31 May 2012 09:36:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Ingo Molnar <mingo@redhat.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Use of high-res timers
In-Reply-To: <Pine.LNX.4.44L0.1205301419090.1543-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.02.1205310932240.3231@ionos>
References: <Pine.LNX.4.44L0.1205301419090.1543-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012, Alan Stern wrote:

> Thomas, Ingo, or anyone else:
> 
> My driver needs to time a bunch of events, with roughly millisecond
> precision.  Up to now it has used old-fashioned timer_lists and the
> jiffies counter, but I'm switching over to high-resolution timers and
> ktime_get.
> 
> This leads to a few questions (these issues don't seem to be addressed 
> anywhere in Documentation/timers):
> 
> 	Should I be concerned about efficiency?  I may well end up
> 	calling ktime_get several times per millisecond; is it fast
> 	enough for this to be okay?

It better is.
 
> 	I need timed intervals with reliable lower bounds.  Let's say
> 	I call ktime_get twice, maybe once in an interrupt handler and
> 	once in an hrtimer callback (not necessarily on the same CPU).
> 	Some action has to be taken no earlier than 1 ms after the 
> 	first call.  If the second call returns a value that is at 
> 	least 1 ms larger than the first call, is that enough of a 
> 	guarantee?  If not, how much larger does it have to be?

ktime_get() is precise. Can you explain what you are trying to solve ?
 
> 	Which has more overhead: adding and cancelling an hrtimer
> 	several times, or simply letting it expire and returning
> 	immediately from the callback?  (I wouldn't be surprised if
> 	there was no good answer.)

There is no really good answer.

Thanks,

	tglx
