Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab0KJUV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:21:26 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45196 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab0KJUVY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:21:24 -0500
MIME-Version: 1.0
In-Reply-To: <20101110201600.GA14145@pengutronix.de>
References: <1288897200-13008-1-git-send-email-dvhart@linux.intel.com>
	<tip-4c115e951d80aff126468adaec7a6c7854f61ab8@git.kernel.org>
	<20101110201600.GA14145@pengutronix.de>
Date: Wed, 10 Nov 2010 12:21:21 -0800
X-Google-Sender-Auth: 3Xoz9GjcD6n-akSEAHAKwXi8LGQ
Message-ID: <AANLkTimH3faSEH_7Lea_M8OoO_dD5MaqjJ9ax_gTZ2C1@mail.gmail.com>
Subject: Re: [tip:core/urgent] futex: Address compiler warnings in exit_robust_list
From: Darren Hart <darren@dvhart.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, jkacur@redhat.com, dvhart@linux.intel.com,
        peterz@infradead.org, matt@console-pimps.org, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/10 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> Hallo Thomas,
>
> On Wed, Nov 10, 2010 at 12:30:44PM +0000, tip-bot for Darren Hart wrote:
>> Commit-ID:  4c115e951d80aff126468adaec7a6c7854f61ab8
>> Gitweb:     http://git.kernel.org/tip/4c115e951d80aff126468adaec7a6c7854f61ab8
>> Author:     Darren Hart <dvhart@linux.intel.com>
>> AuthorDate: Thu, 4 Nov 2010 15:00:00 -0400
>> Committer:  Thomas Gleixner <tglx@linutronix.de>
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
>>       changelog ]
>>
>> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
>> Tested-by: Matt Fleming <matt@console-pimps.org>
>> Tested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> I don't care much (at least until someone claims this change to
> introduce a regression), but I didn't test it.  I only suggested to use
> uninitialized_var instead of = 0.
>

Uwe, I added you after you said I could add the ARM platform and
compiler to the list. I took that to mean you had confirmed that the
patch fixed the warning on that platform. I apologize as this is
apparently not the case.

--
Darren
