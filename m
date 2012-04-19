Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab2DSMqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:46:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:62342 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab2DSMqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:46:30 -0400
Message-ID: <4F900919.7000800@windriver.com>
Date: Thu, 19 Apr 2012 08:46:17 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Chris Zankel <chris@zankel.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] xtensa: fix build failure in xtensa/kernel/signal.c
References: <1334782256-351-1-git-send-email-paul.gortmaker@windriver.com> <1334821525.26997.39.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1334821525.26997.39.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-19 03:45 AM, Matt Fleming wrote:
> On Wed, 2012-04-18 at 16:50 -0400, Paul Gortmaker wrote:
>> Caused by commit 3785006ac3c8941feb63097c416de92114a6bc39
>>
>>     "xtensa: don't mask signals if we fail to setup signal stack"
>>
>> It assigns a return value to "ret", but there is no such variable
>> anywhere in scope.  Create one.
>>
>> Cc: Matt Fleming <matt.fleming@intel.com>
>> Cc: Oleg Nesterov <oleg@redhat.com>
>> Cc: Chris Zankel <chris@zankel.net>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>>
>> diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
>> index b69b000..d78869a 100644
>> --- a/arch/xtensa/kernel/signal.c
>> +++ b/arch/xtensa/kernel/signal.c
>> @@ -496,6 +496,7 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset)
>>  	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
>>  
>>  	if (signr > 0) {
>> +		int ret;
>>  
>>  		/* Are we from a system call? */
>>  
> 
> Whoops! Thanks Paul, that's my bad. Looks like I went code-blind after
> making the same kinds of changes to lots of different architectures.
> 
> I've added Andrew to the Cc list since he picked up the last set of
> xtensa signal patches.

Looks like I'll have a queue of build fixes from various other less
common architectures, so I can carry this one in my for-3.4 queue
(since 3785006a is already in master).

I'll add an acked-by from you.

Paul.

> 
