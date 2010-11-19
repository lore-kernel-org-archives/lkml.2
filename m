Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab0KSOzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 09:55:09 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:7899 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753548Ab0KSOzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 09:55:07 -0500
X-IronPort-AV: E=Sophos;i="4.59,223,1288566000"; 
   d="scan'208";a="88747481"
Date: Fri, 19 Nov 2010 15:55:05 +0100
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
Message-ID: <20101119145505.GO6554@const.bordeaux.inria.fr>
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
References: <201011182333.48281.hpj@urpla.net> <20101118231218.GX6024@const.famille.thibault.fr> <1290123351.18039.49.camel@maggy.simson.net> <20101118234339.GA6024@const.famille.thibault.fr> <AANLkTimTNxLYGLgnS9TUT_YiMnmDVrqseByGGogj+A4Z@mail.gmail.com> <20101119000204.GE6024@const.famille.thibault.fr> <20101119000720.GF6024@const.famille.thibault.fr> <1290167844.2109.1560.camel@laptop> <20101119142418.GN6554@const.bordeaux.inria.fr> <1290177793.2109.1612.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290177793.2109.1612.camel@laptop>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra, le Fri 19 Nov 2010 15:43:13 +0100, a écrit :
> > MPI jobs typically communicate with each other. Keeping them on the same
> > socket permits to keep shared-memory MPI drivers to mostly remain in
> > e.g. the L3 cache. That typically gives benefits.
> 
> Pushing them away permits them to use a larger part of that same L3
> cache allowing them to work on larger data sets.

But then you are not benefitting from all CPU cores.

> Most of the MPI apps
> have a large compute to communication ratio because that is what allows
> them to run in parallel so well (traditionally the interconnects were
> terribly slow to boot), that suggests that working on larger data sets
> is a good thing and running on the same node really doesn't matter since
> communication is assumes slow anyway.

Err, if the compute to communication ratio is big, then you should use
all CPU cores, up to the point where communication becomes a matter
again, and making sure that related MPI processes end up on the same
socket will permit to got a it further.

> There really is no simple solution to his.

I never said there was even a solution, actually (in particular any kind
of generic solution), but that there are a a few simple ways exist to
make things better.

Samuel
