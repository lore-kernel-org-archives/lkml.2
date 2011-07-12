Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab1GLJIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:08:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab1GLJIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:08:38 -0400
Message-ID: <4E1C0F02.9040906@redhat.com>
Date: Tue, 12 Jul 2011 12:08:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Will Deacon <will.deacon@arm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
References: <1309362157-6596-1-git-send-email-avi@redhat.com>	 <1309362157-6596-2-git-send-email-avi@redhat.com>	 <20110629160841.GA2032@somewhere>	 <20110629162725.GH15521@e102144-lin.cambridge.arm.com>	 <20110704135820.GD5551@somewhere> <4E11C9CC.2070909@redhat.com>	 <20110704143655.GE5551@somewhere>	 <20110711210753.GA3582@e102144-lin.cambridge.arm.com>	 <4E1BF5A1.5070301@redhat.com> <1310459898.18678.108.camel@twins>
In-Reply-To: <1310459898.18678.108.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 11:38 AM, Peter Zijlstra wrote:
> On Tue, 2011-07-12 at 10:20 +0300, Avi Kivity wrote:
>
> >  Maybe we need a generic "run this function in this task's context"
> >  mechanism instead.  Like an IPI, but targeting tasks instead of cpus.
> >
>
> kernel/event/core.c:task_function_call() like?

Similar, but with stronger guarantees: when the function is called, 
current == p, and the task was either sleeping or in userspace.

This can be used to reduce synchronization requirements between tasks.  
For example, you can set a task-local bit flag with this, without 
atomics.  If this is rare enough, it's a net win compared to adding atomics.

aio completions might also make use of this.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

