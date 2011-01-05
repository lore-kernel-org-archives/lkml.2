Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab1AERfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:35:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab1AERfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:35:44 -0500
Message-ID: <4D24ABD7.4040503@redhat.com>
Date: Wed, 05 Jan 2011 19:35:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
References: <20110103162637.29f23c40@annuminas.surriel.com>	 <20110103162918.577a9620@annuminas.surriel.com>	 <1294164289.2016.186.camel@laptop>  <4D24A5F4.3000508@redhat.com>	 <1294247718.2016.269.camel@laptop>  <4D24A822.4000009@redhat.com> <1294248511.2016.274.camel@laptop>
In-Reply-To: <1294248511.2016.274.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 07:28 PM, Peter Zijlstra wrote:
> On Wed, 2011-01-05 at 19:19 +0200, Avi Kivity wrote:
> >  On 01/05/2011 07:15 PM, Peter Zijlstra wrote:
> >  >  On Wed, 2011-01-05 at 19:10 +0200, Avi Kivity wrote:
> >  >  >   On 01/04/2011 08:04 PM, Peter Zijlstra wrote:
> >  >  >   >   This definitely wants to be EXPORT_SYMBOL_GPL() and if it were possible
> >  >  >   >   I'd make it so only kvm.o could use it. It really sucks that kvm is a
> >  >  >   >   module.
> >  >  >
> >  >  >   Why does it suck?  I mean apart from the "virtualization is crap" song.
> >  >
> >  >  Because it needs hooks all over the core kernel, like this yield_to()
> >  >  stuff. Exporting this might lead to others wanting to use it too.
> >
> >  Well, it's very convenient for development (modprobe vs. reboot).
>
> Get a machine that boots fast ;-), it might be because I've never worked
> on anything modular, but typically stuff crashes when I got it wrong, in
> which case you're forced to power-cycle anyway.

I often get by with just guest crashes.  Or maybe it oopses, I look 
around, then reboot at my leisure.

> >    What hooks do you object to?
>
> Don't really keep a list, but every now and again see something that
> makes me think that ought not be exported.
>
> >  mmu notifiers are useful for some drivers, sched
> >  notifiers are useful for cmwq and possibly perf?
>
> Both use explicit function calls because its easier to read the code and
> faster.

I doubt it's measurable, especially for perf with the msr tweaking it does.

Tejun, why did you end up not using preempt_notifiers in cmwq?

-- 
error compiling committee.c: too many arguments to function

