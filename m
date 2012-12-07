Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423852Ab2LGBCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:02:41 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60676 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423647Ab2LGBCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:02:38 -0500
MIME-Version: 1.0
In-Reply-To: <50C138DB.70602@intel.com>
References: <1354542848-29638-1-git-send-email-alex.shi@intel.com>
	<1354542848-29638-2-git-send-email-alex.shi@intel.com>
	<CAFTL4hw1Zq+nUG5CXe+7sGNa_1A3YGpe-TBbSTeaPtzXWD57hg@mail.gmail.com>
	<50C138DB.70602@intel.com>
Date: Fri, 7 Dec 2012 02:02:37 +0100
Message-ID: <CAFTL4hyfxXcrgn2WZimoeH0FmNYJ1ZubnD2KM1S6GWVAbymEyA@mail.gmail.com>
Subject: Re: [PATCH 01/10] sched: select_task_rq_fair clean up
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: npiggin@kernel.dk, mingo@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/7 Alex Shi <alex.shi@intel.com>:
> On 12/07/2012 01:50 AM, Frederic Weisbecker wrote:
>> 2012/12/3 Alex Shi <alex.shi@intel.com>:
>>> It is impossible to miss a task allowed cpu in a eligible group.
>>>
>>> And since find_idlest_group only return a different group which
>>> excludes old cpu, it's also imporissible to find a new cpu same as old
>>> cpu.
>>
>> Is it possible for weighted_cpuload() to return ULONG_MAX? If so,
>> find_idlest_cpu() can return -1.
>>
>
> No, non of sched entity can has a ULONG_MAX weight.

Ok. find_idlest_cpu() can still return -1 but select_task_rq_fair() is
the only caller. Presumably safe but code evolves. May be add some
comment to explain why what you're doing is safe. May be a
WARN_ON_ONCE() could be good to add?
