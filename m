Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab0IUNjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 09:39:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20258 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab0IUNjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 09:39:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KyqjrW23b2qfe6YIVU9ut8weocxkail3MR6X2z8mfFkOXQ7pkAVnouqxhN6d2JgMbB
         hSCZD4SVWjkfi/DdAbmQ==
MIME-Version: 1.0
In-Reply-To: <1285072975.2275.872.camel@laptop>
References: <4c88dc9c.991ce30a.3d91.3e0e@mx.google.com>
	<1285061899.2275.824.camel@laptop>
	<1285062228.2275.826.camel@laptop>
	<AANLkTik-oMNJdakwsH=22LzgYvgd35aom+Zu2WkchUte@mail.gmail.com>
	<1285072975.2275.872.camel@laptop>
Date: Tue, 21 Sep 2010 15:38:56 +0200
Message-ID: <AANLkTinmHGtLFRa4O5DNRGgoRtM4cy65JgCw=sYxEjNF@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v3)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 2:42 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-09-21 at 13:48 +0200, Stephane Eranian wrote:
>> The main issue I see with this is that it relies on having at least one
>> task in the cgroup when you start the measurement. That is certainly
>> not always the case.
>
> Hmm, indeed. One thing we can do about that is move perf into the
> cgroup, create the counter (disabled) using self to identify the cgroup,
> move perf back to where it came from, and enable the counter.
>
Yes, that's another possibility. I wonder if there are any non-obvious
difficulties with this approach. Is it as simple as:
   FILE *fp;
   fp = fopen("/dev/cgroup/test/tasks", "w");
   fprintf(fp, "%d", gettid());
   close(fp):

> Its just that I prefer to keep the attach state in the syscall arguments
> and not the perf_event_attr struct.
>
I understand that.

> cgroups are task objects, so it makes sense to use the task attach to
> indicate the cgroup. The empty cgroup case is indeed a tad unfortunate.
> Not having to open more files and pass fds around was also a nice
> benefit.
>
Sure.
