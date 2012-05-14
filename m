Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab2ENAjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 20:39:44 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:35721 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab2ENAjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 20:39:43 -0400
Message-ID: <1336955981.2190.13.camel@shrek.rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        bp@alien8.de
Date: Mon, 14 May 2012 10:39:41 +1000
In-Reply-To: <4FB048A0.9000601@linux.vnet.ibm.com>
References: <1336515735.2097.23.camel@shrek.rexursive.com>
	 <201205122347.08176.rjw@sisk.pl>
	 <8b0184d9-0c54-4f6e-b0b7-ce1b7d854b9e@email.android.com>
	 <201205131510.37664.rjw@sisk.pl>
	 <1336951080.2190.4.camel@shrek.rexursive.com>
	 <4FB048A0.9000601@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 05:19 +0530, Srivatsa S. Bhat wrote:
> But does it carry out suspend-to-ram in full, or does it skip the
> PM_SUSPEND_PREPARE notifications?

As far as I can see, it simply does an ioctl that suspends to RAM
immediately, without any prior notifications.

> See my concerns about the preparation stage for suspend, in my other
> mail as well. I would have been less worried if we did things in full:
> 1. prepare for hibernation
> 2. create image
> 3. prepare for suspend
> 4. do suspend
> 5. do resume
> 6. unwind from hibernation code (like a failed hibernation).
> 
> Still no guarantees, but somewhat better.
> (consider what will happen if some code expects completion of an
> operation,
> successful or otherwise, before starting another.. and hence is
> unprepared
> for something like:
> hibernation prepare -> suspend prepare -> post suspend -> post
> hibernation)

What I'm trying to say is that from the point of view of the rest of the
code, suspend to RAM never happened. Only a failed hibernation happened.

At the point where we suspend to RAM, only the devices that are required
for image writing are actually active. The rest is frozen, including all
the processes, if I'm understanding things correctly.

If these devices can survive a failed image writing and are then be
subjected to unwinding by hibernation code, how would a suspend to RAM
right in the middle change any of this? Maybe it does - don't really
know...

> If we don't rework this thing carefully via a special notification for
> save-image-and-suspend like what Rafael suggested, and instead try to
> go
> with existing stuff as it is, I would definitely suggest putting this
> feature
> under something like CONFIG_EXPERIMENTAL ;-) 

Yeah, possibly.

-- 
Bojan

