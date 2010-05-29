Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab0E2DKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 23:10:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47662 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab0E2DKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 23:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IEPbayRBd1TgbAc1dCsgzIVUNXzpeJNrNyxGd35cNH0coWkjlaxIevagWH8AKREk8G
         qeeJYFj55vKHj6zjb6Q/gWu+uazBfaQcy1d9CRptiY5JG4Ynx8l9R56Iw16wGSi1IPgd
         noMB1NjDmCsq5wszdqi7EvPCTBP7pi4xNxVgc=
Date: Fri, 28 May 2010 20:10:38 -0700
From: mark gross <640e9920@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100529031038.GD11600@gvim.org>
Reply-To: markgross@thegnar.org
References: <alpine.LFD.2.00.1005271545190.3032@localhost.localdomain>
 <Pine.LNX.4.44L0.1005271053420.3239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005271053420.3239-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 11:06:23AM -0400, Alan Stern wrote:
> If people don't mind, here is a greatly simplified summary of the 
> comments and objections I have seen so far on this thread:
> 
> 	The in-kernel suspend blocker implementation is okay, even
> 	beneficial.

Only if they only block.  You get into trouble when the in kernel
un-block opperation triggers an implicit suspend. 


> 
> 	Opportunistic suspends are okay.
> 
> 	The proposed userspace API is too Android-specific.
> 
> 	More kernel mechanisms are needed for expressing processes'
> 	latency requirements.

True.

--mgross

> 
> The last one is obviously a longer-term issue, so let's ignore it for
> now.  That leaves as the only point of contention the userspace
> suspend-blocker API.
> 
> The proposal I made a couple of days ago removes this API and leaves
> the other things (i.e., the in-kernel suspend blockers and
> opportunistic suspend) intact.  In place of the userspace
> kernel-blocker API, Android would have to implement a power manager
> process that would essentially juggle all the latency requirements in
> userspace.
> 
> Communication between the power manager process and the kernel would be 
> limited to adding a new "opportunistic" entry to /sys/power/state -- 
> something which could well be useful in its own right.  Even if this 
> API turns out not to be good, it's simple enough that it could be 
> removed pretty easily.
> 
> This answers Alan Cox's (and other's) desire not to implement a 
> questionable or special-purpose API.  And it also answers Thomas's 
> desire to make scheduling decisions based on latency requirements 
> (although the answer is simply to punt all these decisions out of the 
> kernel and into userspace -- which is reasonable for now since the 
> alternative would require a long-term kernel development effort).
> 
> Indeed, having a power manager thread may well turn out to be a useful
> thing -- but even if it doesn't, this scheme minimizes the damage while
> still allowing the Android platform to use a vanilla kernel with only
> limited modifications to their userspace.
> 
> Alan Stern
> 
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm
