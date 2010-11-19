Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab0KSL5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:57:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:48447 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab0KSL5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:57:31 -0500
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20101119000720.GF6024@const.famille.thibault.fr>
References: <1289916171.5169.117.camel@maggy.simson.net>
	 <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
	 <20101116211431.GA15211@tango.0pointer.de>
	 <201011182333.48281.hpj@urpla.net>
	 <20101118231218.GX6024@const.famille.thibault.fr>
	 <1290123351.18039.49.camel@maggy.simson.net>
	 <20101118234339.GA6024@const.famille.thibault.fr>
	 <AANLkTimTNxLYGLgnS9TUT_YiMnmDVrqseByGGogj+A4Z@mail.gmail.com>
	 <20101119000204.GE6024@const.famille.thibault.fr>
	 <20101119000720.GF6024@const.famille.thibault.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 19 Nov 2010 12:57:24 +0100
Message-ID: <1290167844.2109.1560.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 01:07 +0100, Samuel Thibault wrote:
> 
> 
> Also note that having a hierarchical process structure should permit to
> make things globally more efficient: avoid putting e.g. your cpp, cc1,
> and asm processes at three corners of your 4-socket NUMA machine :) 

We have the hierarchy mandated by POSIX to track parents, childs,
sessions and all that stuff, its just not the data structure used for
scheduling.

And no, using that to load-balance between CPUs doesn't necessarily help
with the NUMA case, load-balancing is an impossible job (equivalent to
page-replacement -- you simply don't know the future), applications
simply do wildly weird stuff. 

>From a process hierarchy there's absolutely no difference between a
cc1/cpp/asm and some MPI jobs, both can be parent-child relations with
pipes between, some just run short and have data affinity, others run
long and don't have any.


