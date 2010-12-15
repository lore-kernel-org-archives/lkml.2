Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0LOOaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:30:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61639 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab0LOOaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:30:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=No8ALD0sCiI/I6K9X91M2HE7ReTDhy7Gzgn4sTeWIWkGf1ILAcwRzOzCTXvvQFzmlF
         bdsI9+dFFg5XWwBvQQksBJVrxB5TLkna3ah29sZcpmevJOPKvQpDzaMEH7VhlpXRe8h8
         z9kvdyGfbCV61ezoqGAYgOrtC+2L9pigXFfTU=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1012151029090.12146@localhost6.localdomain6>
References: <4D07330A.7020600@cn.fujitsu.com>
	<alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
	<4D083900.1050801@cn.fujitsu.com>
	<1292386606.5015.1862.camel@gandalf.stny.rr.com>
	<4D0877D2.10000@cn.fujitsu.com>
	<alpine.LFD.2.00.1012151029090.12146@localhost6.localdomain6>
Date: Wed, 15 Dec 2010 22:24:55 +0800
Message-ID: <AANLkTi=x-_ffBnFL4TMtjGBBpbu9aBvSHKiQ7BgNy7J0@mail.gmail.com>
Subject: Re: [PATCH] rtmutex: ensure only the top waiter or higher priority
 task can take the lock and reduce unrelated boosting
From: Lai Jiangshan <eag0628@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 8:07 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 15 Dec 2010, Lai Jiangshan wrote:
>> +     if (waiter || rt_mutex_has_waiters(lock)) {
>> +             unsigned long flags;
>> +             struct rt_mutex_waiter *top;
>> +
>> +             raw_spin_lock_irqsave(&task->pi_lock, flags);
>> +
>> +             /* remove the queued waiter. */
>> +             if (waiter) {
>> +                     plist_del(&waiter->list_entry, &lock->wait_list);
>> +                     task->pi_blocked_on = NULL;
>> +             }
>> +
>> +             /*
>> +              * We have to enqueue the top waiter(if have) into
>> +              * task->pi_waiters list and would get boost from it.
>
> No, we don't get boosted from it. We just have to enqueue it into
> pi_waiters list. There is no boosting happening at this point. Please
> be very careful with the comments in this code.
>
> Otherwise this looks really interesting. Still this wants to be ported
> to -rt and stress tested there.
>

Hi, Thomas,

Where can I find the code of stress testcases?

Thanks,
Lai
