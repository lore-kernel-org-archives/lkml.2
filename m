Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab0KSOeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 09:34:10 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:15860 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752754Ab0KSOeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 09:34:08 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 09:34:07 EST
X-IronPort-AV: E=Sophos;i="4.59,223,1288566000"; 
   d="scan'208";a="88743548"
Date: Fri, 19 Nov 2010 15:24:18 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101119142418.GN6554@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
	linux-kernel@vger.kernel.org,
	Lennart Poettering <mzxreary@0pointer.de>, david@lang.hm,
	Dhaval Giani <dhaval.giani@gmail.com>,
	Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@elte.hu>,
	Balbir Singh <balbir@linux.vnet.ibm.com>
References: <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com> <20101116211431.GA15211@tango.0pointer.de> <201011182333.48281.hpj@urpla.net> <20101118231218.GX6024@const.famille.thibault.fr> <1290123351.18039.49.camel@maggy.simson.net> <20101118234339.GA6024@const.famille.thibault.fr> <AANLkTimTNxLYGLgnS9TUT_YiMnmDVrqseByGGogj+A4Z@mail.gmail.com> <20101119000204.GE6024@const.famille.thibault.fr> <20101119000720.GF6024@const.famille.thibault.fr> <1290167844.2109.1560.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290167844.2109.1560.camel@laptop>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra, le Fri 19 Nov 2010 12:57:24 +0100, a écrit :
> On Fri, 2010-11-19 at 01:07 +0100, Samuel Thibault wrote:
> > Also note that having a hierarchical process structure should permit to
> > make things globally more efficient: avoid putting e.g. your cpp, cc1,
> > and asm processes at three corners of your 4-socket NUMA machine :) 
> 
> And no, using that to load-balance between CPUs doesn't necessarily help
> with the NUMA case,

It doesn't _necessarily_ help, but it should help in quite a few cases.

> load-balancing is an impossible job (equivalent to
> page-replacement -- you simply don't know the future), applications
> simply do wildly weird stuff. 

Sure. Not a reason not to get the low-hanging fruits :)

> From a process hierarchy there's absolutely no difference between a
> cc1/cpp/asm and some MPI jobs, both can be parent-child relations with
> pipes between, some just run short and have data affinity, others run
> long and don't have any.

MPI jobs typically communicate with each other. Keeping them on the same
socket permits to keep shared-memory MPI drivers to mostly remain in
e.g. the L3 cache. That typically gives benefits.

Samuel
