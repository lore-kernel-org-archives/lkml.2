Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab0FLQCw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 12:02:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28522 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab0FLQCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 12:02:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding;
	b=ef1L6Xru2tX1T66RiLiaopBcMPMNEzE/BI1T9vI99OGHclM6+vILGi2GWPpmk5y1I
	9+q+kUflo3CZofrnlkGlw==
MIME-Version: 1.0
In-Reply-To: <20100612071847.GA29751@elte.hu>
References: <20100612023409.14850.76309.stgit@austin.mtv.corp.google.com> 
	<20100612023457.14850.50439.stgit@austin.mtv.corp.google.com> 
	<20100612071847.GA29751@elte.hu>
From: Divyesh Shah <dpshah@google.com>
Date: Sat, 12 Jun 2010 08:51:54 -0700
Message-ID: <AANLkTinXZ3lHxTcusKxcPG-FWvykcfiDB9lcpZIPLEKx@mail.gmail.com>
Subject: Re: [PATCH 2/2] Use ktime_get() instead of sched_clock() for blkio 
	cgroup stats.
To: Ingo Molnar <mingo@elte.hu>
Cc: jaxboe@fusionio.com, peterz@infradead.org, piotr@hosowicz.com,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 12, 2010 at 12:18 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Divyesh Shah <dpshah@google.com> wrote:
>
>> This will take care of the pre-emptive kernel issue and the unbounded
>> TSC drift problem. We will lose resolution though in some cases.
>
>> -     blkg->stats.start_group_wait_time = sched_clock();
>> +     blkg->stats.start_group_wait_time = ktime_to_ns(ktime_get());
>
> Ugh!
>
> ktime_get() can have insanely high overhead. Peter has added local_clock(), if
> then you should use that and apply checks to make sure the result isnt
> negative.

Ok. The negative checks are already in the code.

>
>        Ingo
>
