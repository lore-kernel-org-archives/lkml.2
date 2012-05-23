Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405Ab2EWPaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:30:22 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:60096 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965117Ab2EWPaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:30:19 -0400
Message-ID: <4FBD0236.7040508@linux.vnet.ibm.com>
Date: Wed, 23 May 2012 17:28:54 +0200
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 0/2] RFC: readd fair sleepers for server systems
References: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com> <1337677268.9698.6.camel@twins>  <4FBCCAE2.7080706@linux.vnet.ibm.com> <1337773798.27020.175.camel@laptop>
In-Reply-To: <1337773798.27020.175.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
x-cbid: 12052315-6892-0000-0000-000001EC4BBC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/23/2012 01:49 PM, Peter Zijlstra wrote:
> On Wed, 2012-05-23 at 13:32 +0200, Christian Ehrhardt wrote:
>>> Why is this, is this some weird interaction with your hypervisor?
>>
>> It is not completely analyzed, as soon as debugging goes out of Linux it
>> can be kind of complex even internally.
>
> Is there significant steal time in these workloads? If so, does it help
> if you implement
> CONFIG_PARAVIRT_TIME_ACCOUNTING/paravirt_steal_rq_enabled for s390?
> (although I guess we'd better loose the paravirt part of the name then).

Interesting, yeah there is enough steal time - not in all, but in most 
cases we had in conflict with fair sleepers so far.
We don't have any code for CONFIG_PARAVIRT and its childs yet, so I need 
to look further into it.

> This 'feature' subtracts steal time from the task-clock so that the
> scheduler doesn't consider a task to be running when the vcpu wasn't
> running as well.
>
> Not doing that (current situation) could result in over-active
> preemption because we think a task ran significantly longer than it
> actually did. Same for sleeper fairness, we might think a task slept
> very long (and give a bigger boost) when in fact it didn't.

Great - sounds like a good thing to check, I'll definitely try this out.
This week we are changing our automation environment, so give me a few 
days for numbers on that.

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance

