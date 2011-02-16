Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab1BPUj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:39:57 -0500
Received: from mail.openrapids.net ([64.15.138.104]:46463 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752544Ab1BPUjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:39:55 -0500
Date: Wed, 16 Feb 2011 15:39:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Roland McGrath <roland@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Julien Desfossez <julien.desfossez@polymtl.ca>,
        dominique.toupin@ericsson.com, ltt-dev@lists.casi.polymtl.ca,
        systemtap@sources.redhat.com, linux-kernel@vger.kernel.org,
        Jason Baron <jbaron@redhat.com>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Porting "jump labels" to userspace
Message-ID: <20110216203953.GB2015@Krystal>
References: <4D5AA164.1050607@polymtl.ca> <y0mvd0ltgba.fsf@fche.csb> <AANLkTi=Nsy6fXE9=Njxs9LPHuohHzf=q5kD+fK765Rht@mail.gmail.com> <1297853778.3224.90.camel@springer.wildebeest.org> <20110216185056.CAD7B1806E0@magilla.sf.frob.com> <20110216200034.GA6066@Krystal> <20110216200449.1EB9618020E@magilla.sf.frob.com> <4D5C30D8.8070107@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5C30D8.8070107@caviumnetworks.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:36:55 up 85 days,  1:39,  4 users,  load average: 0.01, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Daney (ddaney@caviumnetworks.com) wrote:
> On 02/16/2011 12:04 PM, Roland McGrath wrote:
>> IMHO there is not really so much to the in-kernel implementation that it's
>> worth attempting to reuse the code in userland.  Pretty much all the work
>> is in the details of the implementation that would naturally differ a lot
>> in a different context.  If you understand the mechanism and the machine
>> details, then implementing it well for a userland context is not a big deal
>> and is cleaner to do from scratch than shoe-horning kernel-centric code
>> into a wildly different context.
>>
>
> Good point.
>
> Certainly the details of maintaining instruction cache coherency may be  
> different in userspace.

Indeed, the arch-specific parts will need some extra care (which might, in the
worse case scenario, require to suspend a whole process during the update), but
the generic code in jump_label.c and jump_label.h could certainly be reused.

Thanks,

Mathieu

>
> David Daney

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
