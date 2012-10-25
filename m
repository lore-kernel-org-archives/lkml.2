Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab2JYEhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 00:37:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:59388 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab2JYEhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 00:37:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,645,1344236400"; 
   d="scan'208";a="210523881"
Message-ID: <5088C1BE.9010203@linux.intel.com>
Date: Wed, 24 Oct 2012 21:36:14 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] [RESEND 2] Take over futex of dead task only if FUTEX_WAITERS
 is not set
References: <CAAHN_R1O3asyJGXqjs5qt0b_qGR6S6RuM+E_85VaEoWAyAMheQ@mail.gmail.com> <1350876034-22023-1-git-send-email-siddhesh.poyarekar@gmail.com> <5086A3D1.7080709@linux.intel.com> <alpine.LFD.2.02.1210232138540.2756@ionos> <CAAHN_R0jTey+4TOXfKh96aApOPUXQq6wwobejmhFeRuTV2VJKA@mail.gmail.com> <alpine.LFD.2.02.1210242006450.2756@ionos>
In-Reply-To: <alpine.LFD.2.02.1210242006450.2756@ionos>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/24/2012 11:08 AM, Thomas Gleixner wrote:
> On Wed, 24 Oct 2012, Siddhesh Poyarekar wrote:
> 
>>> Now there is a different solution to that problem. Do not look at the
>>> user space value at all and enforce a lookup of possibly available
>>> pi_state. If pi_state can be found, then the new incoming locker T3
>>> blocks on that pi_state and legitimately races with T2 to acquire the
>>> rt_mutex and the pi_state and therefor the proper ownership of the
>>> user space futex.
>>
>> That works. Thanks for the detailed explanation too.
> 
> Thanks for the reproducer and finding the trouble spot in the first
> place!


Absolutely, that was great. Siddhesh, any objection to this test being
incorporated into futextest?

http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git;a=summary

> I'll queue that if Darren has no objections and mark it for stable as
> well.

I would mostly like to understand the stale waiters case you mentioned.
Otherwise, it seems sound - but changing what appears to be a workaround
for an undocumented cornercase in code this complex does make me a bit
nervous. I'd feel better if we could get Siddhesh's and this stale
waiters covered in futextest.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
