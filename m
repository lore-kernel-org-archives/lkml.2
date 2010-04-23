Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab0DWIbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:31:24 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:37173 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab0DWIbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:31:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZiiZvYwAj/bqovGfz7Cwo5gsEU9afttuFGbQjx4M31leObsr9Pq/B/0dmHx+gcvfoG
         WhdEeP2DgKsZkCz1zQGS7jHh/xWpCWPlNAwdyxvtLAbrlh8/K5Py0Ve1myj0HH8csRcj
         pDeQE9pW9Lv4hmcVLyB+h73mOqX+2oJT6Xv6Y=
MIME-Version: 1.0
In-Reply-To: <1272009915.1646.25.camel@laptop>
References: <alpine.LFD.2.00.1004222208310.3155@localhost>
	 <20100423025850.GA21328@windriver.com>
	 <alpine.LFD.2.00.1004230907050.4151@localhost>
	 <1272009915.1646.25.camel@laptop>
Date: Fri, 23 Apr 2010 10:31:16 +0200
X-Google-Sender-Auth: 4b518e0218a57937
Message-ID: <w2v520f0cf11004230131i743c596emfd0e5b8870330a8b@mail.gmail.com>
Subject: Re: [PATCH] lockdep: Add nr_save_trace_invocations counter
From: John Kacur <jkacur@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yong Zhang <yong.zhang@windriver.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 10:05 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-04-23 at 09:24 +0200, John Kacur wrote:
>> direct dependencies:                  8752 [max: 16384]
>> I have
>> stack-trace invocations: 10888
>> from the same run.
>>
>> Still trying to figure out what the meaning is of that though to be
>> honest.
>>
>> Here is a portion of the lockdep_stats, with all of the new fields and the
>> redundant ones.
>>
>> stack-trace invocations: 10888
>>         LOCK_USED_IN_HARDIRQ: 15
>>         LOCK_USED_IN_HARDIRQ_READ: 0
>>         LOCK_ENABLED_HARDIRQ: 543
>>         LOCK_ENABLED_HARDIRQ_READ: 28
>>         LOCK_USED_IN_SOFTIRQ: 0
>>         LOCK_USED_IN_SOFTIRQ_READ: 0
>>         LOCK_ENABLED_SOFTIRQ: 543
>>         LOCK_ENABLED_SOFTIRQ_READ: 28
>>         LOCK_USED_IN_RECLAIM_FS: 5
>>         LOCK_USED_IN_RECLAIM_FS_READ: 0
>>         LOCK_ENABLED_RECLAIM_FS: 95
>>         LOCK_ENABLED_RECLAIM_FS_READ: 8
>>         LOCK_USED: 871
>
> 8752+871+8+95+5+28+543+28+543+15=10888
>
> So you get a stack-trace for each direct-dependency, and you get a
> stack-trace for each LOCK_state, the sum seems to match the total
> invocations.
>
> Non of these numbers look strange..
>

As I told Peter privately the laptop that triggered the
MAX_STACK_TRACE_ENTRIES every time, has met an
unfortunate early demise. However, I think it was the config - not the
hardware. On this machine where the above
numbers come from, I believe I have less debug options configured -
but it is running the exact same kernel as
the laptop was. (2.6.33.2-rt13)
