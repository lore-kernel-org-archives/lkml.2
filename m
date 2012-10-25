Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab2JYITc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:19:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:27472 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab2JYIT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:19:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,646,1344236400"; 
   d="scan'208";a="238184021"
Message-ID: <5088F5D0.7010604@linux.intel.com>
Date: Thu, 25 Oct 2012 01:18:24 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] [RESEND 2] Take over futex of dead task only if FUTEX_WAITERS
 is not set
References: <CAAHN_R1O3asyJGXqjs5qt0b_qGR6S6RuM+E_85VaEoWAyAMheQ@mail.gmail.com> <1350876034-22023-1-git-send-email-siddhesh.poyarekar@gmail.com> <5086A3D1.7080709@linux.intel.com> <alpine.LFD.2.02.1210232138540.2756@ionos> <5088C10C.80503@linux.intel.com> <alpine.LFD.2.02.1210250936270.2756@ionos>
In-Reply-To: <alpine.LFD.2.02.1210250936270.2756@ionos>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/25/2012 01:14 AM, Thomas Gleixner wrote:
> On Wed, 24 Oct 2012, Darren Hart wrote:
>> On 10/23/2012 01:29 PM, Thomas Gleixner wrote:

> Nah. I'm just too paranoid to apply any futex patch w/o understanding
> the root cause of it.  Darn, if I only could remember how that stale
> waiters bit issue got inflicted ....

Stale waiters happens in userspace for non-pi mutexes and there we make
one extra FUTEX_WAKE syscall just in case. The futex value policy is much
more rigid with PI obviously, so I wasn't aware this could happen there.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
