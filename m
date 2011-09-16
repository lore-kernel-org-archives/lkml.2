Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab1IPIG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 04:06:56 -0400
Received: from smtp-out.google.com ([216.239.44.51]:56052 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1IPIGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 04:06:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:message-id:date:from:user-agent:
	mime-version:newsgroups:to:cc:subject:references:in-reply-to:
	content-type:content-transfer-encoding:x-system-of-record;
	b=ebQUbCkN06K0WdbUpLkmydovtk/KAdluBvX7FY+tq0ep3FnWBhwfLeDqUyTS4WVnZ
	O/kkiuk9no0JhEfdZ+SIA==
Message-ID: <4E730397.5030902@google.com>
Date: Fri, 16 Sep 2011 01:06:47 -0700
From: Paul Turner <pjt@google.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Vladimir Davydov <vdavydov@parallels.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [patch 00/18] CFS Bandwidth Control v7.2
References: <20110721164325.231521704@google.com> <1315915848.1151.26.camel@dhcp-10-30-22-158.sw.ru>
In-Reply-To: <1315915848.1151.26.camel@dhcp-10-30-22-158.sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vladimir,

I had a fairly good coversation with Pavel at LPC regarding these 
questions, it's probably worth syncing up with him and then following up 
if you still have questions.


On 09/13/11 05:10, Vladimir Davydov wrote:
> Hello, Paul
>
> I have a question about CFS bandwidth control.
>
> Let's consider a cgroup with several (>1) tasks running on a two CPU
> host. Let the limit of the cgroup be 50% (e.g. period=1s, quota=0.5s).
> How will tasks of the cgroup be distributed between the two CPUs? Will
> they all run on one of the CPUs, or will one half of them run on one CPU
> and others run on the other?
>

Parallelism is unconstrained until the bandwidth limit is reached, at 
which point we CONFIG_NR_CPUS=0

> Although in both cases the tasks will consume not more than one half of
> overall CPU time, the first case (all tasks of the cgroup run on the
> same CPU) is obviously better if the tasks are likely to communicate
> with each other (e.g. through pipe) which is often the case when cgroups
> are used for container virtualization.
>

This case is handled already by the affine wake-up path.

> In other words, I'd like to know if your code (or the scheduler code)
> tries to gather all tasks of the same cgroup on such a subset of all
> CPUs so that the tasks can't execute less CPUs without losing quota
> during each period. And if not, are you going to address the issue?
>

Parallelism != Bandwidth; no plans at this time.

Thanks!

- Paul
