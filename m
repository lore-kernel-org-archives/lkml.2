Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab1HBGH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 02:07:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:10239 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab1HBGH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 02:07:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,305,1309762800"; 
   d="scan'208";a="34516205"
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: Revert needed: udev spewing warnons on common systems in 3.0
References: <20110802005206.GA3832@tassilo.jf.intel.com>
	<alpine.DEB.2.00.1108011928530.15596@chino.kir.corp.google.com>
Date: Mon, 01 Aug 2011 23:07:55 -0700
In-Reply-To: <alpine.DEB.2.00.1108011928530.15596@chino.kir.corp.google.com>
	(David Rientjes's message of "Mon, 1 Aug 2011 19:34:40 -0700 (PDT)")
Message-ID: <m2pqko1h38.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes <rientjes@google.com> writes:

>
>> Also the warning is completely useless: noone will be "fixing"
>> udev on old distributions.
>> 
>
> udev was fixed for v162, but admittedly that won't help on old 

Nobody wants to update udev if they can avoid it, especially not for
such an extremly obscure reason.

Repeat after me: Linux is not supposed to break old user land.

And not breaking in this case includes not randomly spewing useless
backtraces.

If you feel the need to social engineer the Chromium people, please
do it by email, not by keeping other people's  kernel logs hostage.

> distributions.  The WARN_ONCE() was intended to be in place for a year 
> just like its previous form, printk_once(), and then the tunable will 
> disappear and result in no error message.

printk_once() is fine, but oopsy looking backtraces are not.

>> IMHO that's not acceptable to break common user land like this.
>> Linux is supposed to be binary compatible and this patch is not
>> in this spirit.
>> 
>
> Can you show additional breakage that still need to be fixed in userspace 
> applications (we can't do anything about old distributions, it'll be a 
> silent failure in a year's time)? 

Simply backtraces are not supposed to happen unless something 
is really broken. That's not the case here. The old distribution
works perfectly fine and will continue to do so.

> udev was fixed for v162, kde was fixed 
> for 4.6.1

... and users will continue to run old versions.


> So I'm certainly not changing an interface and leaving people to fix it 
> up, I've been actively involved in doing so for the known userspace that 
> does touch the tunable.  I think it's better for users to be notified 
> whether by "scary" warnings in the log (come on, we should be able to warn 
> about deprecated interfaces in a log without mass failures) as some

You can warn, but not using oopsy looking backtraces. That trigger
all the bug reporting machinery. That is just  annoying.

> diligence before removing the tunable. 

It's not due diligence, it's total overkill for this.

I still think reverting this patch is the right thing to do.

Otherwise I have to do it in my local trees :-/ (it's certainly preferable
than messing with udev)

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
