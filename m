Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab1IWXuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:50:20 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50877 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1IWXuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:50:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=ojiByJav90Li5QnkscUhURwBUS91hPKeP86796XmqkmAGrmHUt1vjC/fOBeXW9QRo
	I8hfuXdGgiaqDZsOe/tAw==
MIME-Version: 1.0
In-Reply-To: <4E7CDE1F.90004@linux.intel.com>
References: <1316804080-6396-1-git-send-email-venki@google.com>
	<4E7CDE1F.90004@linux.intel.com>
Date: Fri, 23 Sep 2011 16:50:15 -0700
Message-ID: <CABeCy1aS2mb3oLjCf5kbAN55MuePS6hbs+2v9Z=X4bFPOmH7HQ@mail.gmail.com>
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
From: Venki Pallipadi <venki@google.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 12:29 PM, Arjan van de Ven
<arjan@linux.intel.com> wrote:
> On 9/23/2011 11:54 AM, Venkatesh Pallipadi wrote:
>>
>> Current hrtimer range timers reduces the number of timer interrupts by
>> grouping together softexpired timers until the next unexpired timer.
>> It does not look at softexpired timers that may be after the unexpired
>> timer in the rbtree.
>>
>> Specifically, as the comment in hrtimer.c says
>>                         * The immediate goal for using the softexpires is
>>                         * minimizing wakeups, not running timers at the
>>                         * earliest interrupt after their soft expiration.
>>                         * This allows us to avoid using a Priority Search
>>                         * Tree, which can answer a stabbing querry for
>>                         * overlapping intervals and instead use the simple
>>                         * BST we already have.
>>                         * We don't add extra wakeups by delaying timers
>> that
>>                         * are right-of a not yet expired timer, because
>> that
>>                         * timer will have to trigger a wakeup anyway.
>>
>
>
> Since you found that it now makes a difference, I'm all for it..
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>
>
> (at original introduction it was in the noise, but usage patterns clearly
> changed a lot and ranges are much more prevalent now)
>
> I would not do the sysctl/configurability thing though.... that's not worth
> it.
>

Yes. I kept the sysctl there for this RFC, so that anyone testing this
can easily switch this on/off and measure the impact. Will remove it
in updates..

Thanks,
Venki
