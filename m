Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0IVK01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 06:26:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59024 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab0IVK00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:26:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n8+of9nYWWCODePojAYJd++mbBF3/DD2Ryhj6cFZjWeQwpsqgtTwfaQZbApX6eXB+2
         tLcUnKLFHi1T/W71M2VA==
MIME-Version: 1.0
In-Reply-To: <20100922091834.GJ6676@balbir.in.ibm.com>
References: <4c88dc9c.991ce30a.3d91.3e0e@mx.google.com>
	<1285061899.2275.824.camel@laptop>
	<20100922042354.GG6676@balbir.in.ibm.com>
	<1285140479.2275.893.camel@laptop>
	<20100922091834.GJ6676@balbir.in.ibm.com>
Date: Wed, 22 Sep 2010 12:26:20 +0200
Message-ID: <AANLkTinMsY3KcL7v9R_uwSzVcMVYvsnXHMrbG6Z9XeL4@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v3)
From: Stephane Eranian <eranian@google.com>
To: balbir@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        robert.richter@amd.com, acme@redhat.com,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ok, early testing shows that this seems to be working fine with the
pid approach.
Of course it is less convenient than just opening a file descriptor in
cgroup_fs.
There is more bookkeeping involved, incl. cleanup the child on exit.

The other thing is related to how to indicate we want cgroup and not per-thread.
For now, my patch is using a new attr.cgroup bit. The alternative is to use a
bit in the flags parameter to the syscall.

On Wed, Sep 22, 2010 at 11:18 AM, Balbir Singh
<balbir@linux.vnet.ibm.com> wrote:
> * Peter Zijlstra <peterz@infradead.org> [2010-09-22 09:27:59]:
>
>> On Wed, 2010-09-22 at 09:53 +0530, Balbir Singh wrote:
>> > Yes, a task can belong to multiple subsystems, hence multiple cgroups.
>> > Ideally we'd want to use pid + subsystem
>>
>> Apparently we create a perf subsystem, and we only care about that. So
>> pid will uniquely identify a cgroup, since for each subsystem a task can
>> only belong to one cgroup.
>
> Hmm.. I misread the intention to mean we care about monitoring all
> data and aggregate it for each cgroup.
>
>>
>> > > One thing we could do is pass this cgroup identifier in the pid field
>> > > and use PERF_FLAG_CGROUP or something. Currently the syscall signature
>> > > uses pid_t, but I think we can safely change that to int.
>> >
>> > Or union it and overload the field to contain either pid_t or fd of the cgroup
>>
>> Its not a field, its an argument.
>
> Thanks!
>
> --
>        Three Cheers,
>        Balbir
>
