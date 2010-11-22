Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab0KVGWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 01:22:54 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51925 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab0KVGWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 01:22:53 -0500
Date: Mon, 22 Nov 2010 11:52:42 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101122062242.GE12043@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1289916171.5169.117.camel@maggy.simson.net>
 <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
 <20101116211431.GA15211@tango.0pointer.de>
 <201011182333.48281.hpj@urpla.net>
 <20101118231218.GX6024@const.famille.thibault.fr>
 <1290123351.18039.49.camel@maggy.simson.net>
 <20101118234339.GA6024@const.famille.thibault.fr>
 <1290167376.2109.1553.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1290167376.2109.1553.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2010-11-19 12:49:36]:

> On Fri, 2010-11-19 at 00:43 +0100, Samuel Thibault wrote:
> > What overhead? The implementation of cgroups is actually already
> > hierarchical. 
> 
> It must be nice to be that ignorant ;-) Speaking for the scheduler
> cgroup controller (that being the only one I actually know), most all
> the load-balance operations are O(n) in the number of active cgroups,
> and a lot of the cpu local schedule operations are O(d) where d is the
> depth of the cgroup tree.
>
> [ and that's with the .38 targeted code, current mainline is O(n ln(n))
> for load balancing and truly sucks on multi-socket ]
>

I can say that for memory, with hierarchies we account all the way up,
which can be a visible overhead, depending on how often you fault.
 

-- 
	Three Cheers,
	Balbir
