Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699Ab0KQPCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:02:18 -0500
Received: from tango.0pointer.de ([85.214.72.216]:35544 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab0KQPCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:02:17 -0500
Date: Wed, 17 Nov 2010 16:01:56 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101117150156.GA17082@tango.0pointer.de>
References: <20101116181603.GC19327@tango.0pointer.de>
 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <20101116202839.GC27235@tango.0pointer.de>
 <20101116205243.64e4a67a@lxorguk.ukuu.org.uk>
 <AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com>
 <20101116211909.GB16589@tango.0pointer.de>
 <20101116233934.GC1568@thunk.org>
 <20101117002159.GA3184@tango.0pointer.de>
 <20101117020626.GB3290@thunk.org>
 <20101117145712.GA29892@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117145712.GA29892@redhat.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17.11.10 09:57, Vivek Goyal (vgoyal@redhat.com) wrote:

> Being able to specify cgroup name/path is a good idea. That way one can
> make use of cgroup hierarchy also.
> 
> Thinking more about opt-in vs opt-out issue. Generally cgroups provide
> some kind of isolation between application groups and in the process
> can be somewhat expensive. More memory allocation, more accounting overhead
> and for CFQ block controller it can also mean additional idling and can result
> in overall reduced throughput.
> 
> Keeping that in mind, is it really a good idea to launch each application
> in a separate group. Will it be better to let user decide if the
> application should be launched in a separate cgroup? 
> 
> The flip side is that how many people will really know about the functionality
> and will really launch application in a separate group. And may be it is
> a good idea to put everybody in a seprate cgroup by default even it means
> some cost so that if a application starts consuming too much of resources
> (make -j64), then its impact on rest of the groups can be contained.
> 
> I really don't have strong inclination for one over other. Just thinking
> loud...

I wouldn't be too concerned here. It's not that we end up with 1000s of
groups here. It's way < 40 or in the end, for a single user
machine. Which I think isn't that bad.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
