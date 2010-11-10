Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab0KJUWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:22:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:17554 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab0KJUWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:22:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,179,1288594800"; 
   d="scan'208";a="856253328"
Message-ID: <4CDAFF11.9030601@linux.intel.com>
Date: Wed, 10 Nov 2010 12:22:41 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, jkacur@redhat.com, peterz@infradead.org,
        matt@console-pimps.org, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] futex: Address compiler warnings in	exit_robust_list
References: <1288897200-13008-1-git-send-email-dvhart@linux.intel.com> <tip-4c115e951d80aff126468adaec7a6c7854f61ab8@git.kernel.org> <20101110201600.GA14145@pengutronix.de>
In-Reply-To: <20101110201600.GA14145@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2010 12:16 PM, Uwe Kleine-König wrote:
> Hallo Thomas,
>
> On Wed, Nov 10, 2010 at 12:30:44PM +0000, tip-bot for Darren Hart wrote:
>> Commit-ID:  4c115e951d80aff126468adaec7a6c7854f61ab8
>> Gitweb:     http://git.kernel.org/tip/4c115e951d80aff126468adaec7a6c7854f61ab8
>> Author:     Darren Hart<dvhart@linux.intel.com>
>> AuthorDate: Thu, 4 Nov 2010 15:00:00 -0400
>> Committer:  Thomas Gleixner<tglx@linutronix.de>
>> CommitDate: Wed, 10 Nov 2010 13:27:50 +0100
>>
>> futex: Address compiler warnings in exit_robust_list
>>
>> Since commit 1dcc41bb (futex: Change 3rd arg of fetch_robust_entry()
>> to unsigned int*) some gcc versions decided to emit the following
>> warning:
>>
>> kernel/futex.c: In function ‘exit_robust_list’:
>> kernel/futex.c:2492: warning: ‘next_pi’ may be used uninitialized in this function
>>
>> The commit did not introduce the warning as gcc should have warned
>> before that commit as well. It's just gcc being silly.
>>
>> The code path really can't result in next_pi being unitialized (or
>> should not), but let's keep the build clean. Annotate next_pi as an
>> uninitialized_var.
>>
>> [ tglx: Addressed the same issue in futex_compat.c and massaged the
>>    	changelog ]
>>
>> Signed-off-by: Darren Hart<dvhart@linux.intel.com>
>> Tested-by: Matt Fleming<matt@console-pimps.org>
>> Tested-by: Uwe Kleine-König<u.kleine-koenig@pengutronix.de>
> I don't care much (at least until someone claims this change to
> introduce a regression), but I didn't test it.  I only suggested to use
> uninitialized_var instead of = 0.


Uwe,

I added you after you said I could add the ARM platform and compiler to 
the list. I took that to mean you had confirmed that the patch fixed the 
warning on that platform. I apologize as this is apparently not the case.

--
Darren
