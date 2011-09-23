Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab1IWT3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 15:29:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:29006 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab1IWT3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 15:29:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="55309854"
Message-ID: <4E7CDE1F.90004@linux.intel.com>
Date: Fri, 23 Sep 2011 12:29:35 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Venkatesh Pallipadi <venki@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
References: <1316804080-6396-1-git-send-email-venki@google.com>
In-Reply-To: <1316804080-6396-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/2011 11:54 AM, Venkatesh Pallipadi wrote:
> Current hrtimer range timers reduces the number of timer interrupts by
> grouping together softexpired timers until the next unexpired timer.
> It does not look at softexpired timers that may be after the unexpired
> timer in the rbtree.
>
> Specifically, as the comment in hrtimer.c says
> 			 * The immediate goal for using the softexpires is
> 			 * minimizing wakeups, not running timers at the
> 			 * earliest interrupt after their soft expiration.
> 			 * This allows us to avoid using a Priority Search
> 			 * Tree, which can answer a stabbing querry for
> 			 * overlapping intervals and instead use the simple
> 			 * BST we already have.
> 			 * We don't add extra wakeups by delaying timers that
> 			 * are right-of a not yet expired timer, because that
> 			 * timer will have to trigger a wakeup anyway.
>


Since you found that it now makes a difference, I'm all for it..
Acked-by: Arjan van de Ven <arjan@linux.intel.com>

(at original introduction it was in the noise, but usage patterns 
clearly changed a lot and ranges are much more prevalent now)

I would not do the sysctl/configurability thing though.... that's not 
worth it.

