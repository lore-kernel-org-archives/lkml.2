Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424250Ab2LGBZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:25:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:26942 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423341Ab2LGBZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:25:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,234,1355126400"; 
   d="scan'208";a="260232013"
Message-ID: <50C144EE.3040308@intel.com>
Date: Fri, 07 Dec 2012 09:22:54 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: npiggin@kernel.dk, mingo@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 01/10] sched: select_task_rq_fair clean up
References: <1354542848-29638-1-git-send-email-alex.shi@intel.com> <1354542848-29638-2-git-send-email-alex.shi@intel.com> <CAFTL4hw1Zq+nUG5CXe+7sGNa_1A3YGpe-TBbSTeaPtzXWD57hg@mail.gmail.com> <50C138DB.70602@intel.com> <CAFTL4hyfxXcrgn2WZimoeH0FmNYJ1ZubnD2KM1S6GWVAbymEyA@mail.gmail.com>
In-Reply-To: <CAFTL4hyfxXcrgn2WZimoeH0FmNYJ1ZubnD2KM1S6GWVAbymEyA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 09:02 AM, Frederic Weisbecker wrote:
> 2012/12/7 Alex Shi <alex.shi@intel.com>:
>> On 12/07/2012 01:50 AM, Frederic Weisbecker wrote:
>>> 2012/12/3 Alex Shi <alex.shi@intel.com>:
>>>> It is impossible to miss a task allowed cpu in a eligible group.
>>>>
>>>> And since find_idlest_group only return a different group which
>>>> excludes old cpu, it's also imporissible to find a new cpu same as old
>>>> cpu.
>>>
>>> Is it possible for weighted_cpuload() to return ULONG_MAX? If so,
>>> find_idlest_cpu() can return -1.
>>>
>>
>> No, non of sched entity can has a ULONG_MAX weight.
> 
> Ok. find_idlest_cpu() can still return -1 but select_task_rq_fair() is
> the only caller. Presumably safe but code evolves. May be add some
> comment to explain why what you're doing is safe. May be a
> WARN_ON_ONCE() could be good to add?
> 

why you think it is possible to be -1?
And there is a WARN_ON_ONCE for cpu = -1 in find_idlest_group when
checking local_group.

Thanks!

