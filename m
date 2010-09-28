Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257Ab0I1JXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 05:23:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51091 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab0I1JXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 05:23:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=l6u6owAfveJ4D2Z1U+bA1ALplWeKZ/ivBwzTA/N/cVgKCySmKPcL914EsX6PTMTqh5
         Z23an3iCBVxjV0vcaPIQ==
MIME-Version: 1.0
In-Reply-To: <1285408287.2275.1061.camel@laptop>
References: <4c88dc9c.991ce30a.3d91.3e0e@mx.google.com>
	<1285061899.2275.824.camel@laptop>
	<20100922042354.GG6676@balbir.in.ibm.com>
	<1285140479.2275.893.camel@laptop>
	<20100922091834.GJ6676@balbir.in.ibm.com>
	<AANLkTinMsY3KcL7v9R_uwSzVcMVYvsnXHMrbG6Z9XeL4@mail.gmail.com>
	<1285408287.2275.1061.camel@laptop>
Date: Tue, 28 Sep 2010 11:23:28 +0200
Message-ID: <AANLkTi=mV0hxgN-KXzgndR6U5KRBmmynJdBTDBaCxVSN@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v3)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 11:51 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-09-22 at 12:26 +0200, Stephane Eranian wrote:
>
>> Ok, early testing shows that this seems to be working fine with the
>> pid approach. Of course it is less convenient than just opening a file
>> descriptor in cgroup_fs. There is more bookkeeping involved, incl.
>> cleanup the child on exit.
>
> Right, so another approach, similar to what you initially proposed,
> would be to have this cgroup file, but instead of simply opening and
> passing the fd around, have it provide a cgroup id and pass that around
> as an integer (or pid_t) in the task argument to the SYSCALL (see the
> flag bit below).
>
> You can use the regular lib/idr.c bits to generate ids and maintain an
> id->cgroup map.
>
What's the advantage of that compared to just passing the fd in the
pid argument?
You can close the fd right after returning from perf_event_open().

>> The other thing is related to how to indicate we want cgroup and not per-thread.
>> For now, my patch is using a new attr.cgroup bit. The alternative is to use a
>> bit in the flags parameter to the syscall.
>
> Right, I prefer a bit in the syscall flags argument and somehow using
> the task argument.
>
