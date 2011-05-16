Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1EPUvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:51:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41629 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab1EPUvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:51:51 -0400
Date: Mon, 16 May 2011 22:51:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Steve Munroe <sjmunroe@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        libc-alpha@sourceware.org, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 4/5] Add a sysconf syscall
Message-ID: <20110516205150.GG25898@one.firstfloor.org>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org> <1305329059-2017-5-git-send-email-andi@firstfloor.org> <BANLkTikP==HkDSG1oKcfSKAhrWOXRqGF5w@mail.gmail.com> <20110516160114.GA25898@one.firstfloor.org> <OF30360F87.5C6D6DCF-ON86257892.005D7E68-86257892.005E0059@us.ibm.com> <20110516173956.GE25898@one.firstfloor.org> <OFD2EE69FB.301A458A-ON86257892.00631BE8-86257892.006A93AF@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFD2EE69FB.301A458A-ON86257892.00631BE8-86257892.006A93AF@us.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The syscall is only current if you call it frequently (i.e. every time),
> but there is tendency to go local (static memory) caching to avoid the
> syscall overhead. Something like _SC_NPROCESSORS_ONLN that is used to set
> up OpenMP/auto-parallel threading for major loops is likely to be cached.

That is true. Still I assume other programs would ask for it more frequently.

Longer term at some point we probably need a proper CPU hotplug
event interface, but short term polling is the standard model.

> 
> But if you look at the gettimeofday/vdso implementation, the time_base to
> time conversion is semi-dynamic for the NTPd case and we handle that in
> VDSO. There is shared memory access between the VDSO and the kernel for
> this case.

Yes, I wrote that code for x86 ;-)

> Is problem with rlimit that it is process or session dependent? But is it
> really dynamic once a process starts?

It can be changed any time per thread (actually per signal context).
Now that's probably not common, but I don't think a new ABI should
ignore the possibility of it changing anyways.

> It is not clear one size fits all here.

What partition would you suggest?

Also do you have a use case where the syscall is too slow?

I'm basically trying to find a good tradeoff for implementation effort
vs usefullness vs good semantics vs performance here.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
