Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab0KSLuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:50:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:58378 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab0KSLuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:50:00 -0500
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20101118234339.GA6024@const.famille.thibault.fr>
References: <1289916171.5169.117.camel@maggy.simson.net>
	 <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
	 <20101116211431.GA15211@tango.0pointer.de>
	 <201011182333.48281.hpj@urpla.net>
	 <20101118231218.GX6024@const.famille.thibault.fr>
	 <1290123351.18039.49.camel@maggy.simson.net>
	 <20101118234339.GA6024@const.famille.thibault.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 19 Nov 2010 12:49:36 +0100
Message-ID: <1290167376.2109.1553.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 00:43 +0100, Samuel Thibault wrote:
> What overhead? The implementation of cgroups is actually already
> hierarchical. 

It must be nice to be that ignorant ;-) Speaking for the scheduler
cgroup controller (that being the only one I actually know), most all
the load-balance operations are O(n) in the number of active cgroups,
and a lot of the cpu local schedule operations are O(d) where d is the
depth of the cgroup tree.

[ and that's with the .38 targeted code, current mainline is O(n ln(n))
for load balancing and truly sucks on multi-socket ]

You add a lot of pointer chasing to all the scheduler fast paths and
there is quite significant data size bloat for even compiling with the
controller enabled, let alone actually using the stuff.

But sure, treat them as if they were free to use, I guess your machine
is fast enough.


