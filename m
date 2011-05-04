Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab1EDVFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:05:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:31621 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab1EDVFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:05:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,316,1301900400"; 
   d="scan'208";a="742459720"
From: Andi Kleen <andi@firstfloor.org>
To: Max Asbock <masbock@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] time: Add locking to xtime access in get_seconds()
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>
	<1304527860.21305.5.camel@w-amax.beaverton.ibm.com>
Date: Wed, 04 May 2011 14:05:35 -0700
In-Reply-To: <1304527860.21305.5.camel@w-amax.beaverton.ibm.com> (Max Asbock's
	message of "Wed, 04 May 2011 09:51:00 -0700")
Message-ID: <m2mxj2yy5c.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Asbock <masbock@linux.vnet.ibm.com> writes:

> On Tue, 2011-05-03 at 20:11 -0700, John Stultz wrote:
>> From: John Stultz <johnstul@us.ibm.com>
>> 
>> So get_seconds() has always been lock free, with the assumption
>> that accessing a long will be atomic.
>> 
>
> get_seconds() is used in the x86 machine check handler and there is a
> comment saying:
> /* We hope get_seconds stays lockless */
>
> This needs to be carefully looked at if locking is introduced to
> get_seconds().

Yes the seqlock being interrupted by an MCE would deadlock.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
