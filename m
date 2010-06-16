Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab0FPQlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:41:09 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:47030 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab0FPQlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:41:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=LcvLqkAlMQnu2b16rXYtanq5rVHojnsHn4y2/XkpaD7AGnHYVAARCCV5rs5TSvrfr0
         Ik7Go9SEMPAGjdqAqb42tEvFFiyoIOByCFvBBP+S+i2aWda2mo+8l7jR0d2HKgN6B6VW
         DOIdCHhyN5d2L/QlOfqMJFCAqVMZBcQPT3ulY=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1276699962.1745.599.camel@laptop>
References: <AANLkTikvExLi_MahU3kkX1TQKvBODq8SyTSXgpyAjOay@mail.gmail.com>
	<1276699962.1745.599.camel@laptop>
Date: Wed, 16 Jun 2010 18:41:03 +0200
Message-ID: <AANLkTim1yFwS5g-s_2fMRHljjf5yMouoHb2Ulqj6V1AC@mail.gmail.com>
Subject: Re: [RFC] perf/perf_events: misleading number of samples due to 
	mmap()
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 4:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-06-16 at 16:40 +0200, Stephane Eranian wrote:
>> This leads me to another point. For per-thread sampling, why
>> do we need to record mmap() events happening *outside* of
>> the process? I can understand the exception of kernel modules.
>
> How does that happen? The per-thread events should be on the per-task
> context, so another task's mmap() events should never end up there.
>

I don't see the test that says the vma does not belong to the current task.
I also don't see anything in perf_event_mmap_match().

It does seem to work as you said in recent kernels, though. So I am certainly
missing something here.
