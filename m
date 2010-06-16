Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab0FPRPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 13:15:41 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:42294 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493Ab0FPRPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 13:15:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=OoJCFIikttmFNejqJ5lKhyZaQNmbMFHqmIY/NTAjc2PYjX/IZo9O3LknqT8tuZpypG
         RMLkmODFpDbenZGonAk1IANDaVQRsZE+aTQSXW7rBbxEHkHCT6lEY6+K16ezMOuGJVPw
         mKHFUpGr+cS+SXobN0NOME4+NAN2NBq+jS1ws=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <AANLkTim1yFwS5g-s_2fMRHljjf5yMouoHb2Ulqj6V1AC@mail.gmail.com>
References: <AANLkTikvExLi_MahU3kkX1TQKvBODq8SyTSXgpyAjOay@mail.gmail.com>
	<1276699962.1745.599.camel@laptop>
	<AANLkTim1yFwS5g-s_2fMRHljjf5yMouoHb2Ulqj6V1AC@mail.gmail.com>
Date: Wed, 16 Jun 2010 19:15:37 +0200
Message-ID: <AANLkTilWIn9VOsIvxQB4BamD7RguNiirtNVTt60hW7XQ@mail.gmail.com>
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

On Wed, Jun 16, 2010 at 6:41 PM, stephane eranian
<eranian@googlemail.com> wrote:
> On Wed, Jun 16, 2010 at 4:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Wed, 2010-06-16 at 16:40 +0200, Stephane Eranian wrote:
>>> This leads me to another point. For per-thread sampling, why
>>> do we need to record mmap() events happening *outside* of
>>> the process? I can understand the exception of kernel modules.
>>
>> How does that happen? The per-thread events should be on the per-task
>> context, so another task's mmap() events should never end up there.
>>
>
> I don't see the test that says the vma does not belong to the current task.
> I also don't see anything in perf_event_mmap_match().
>
> It does seem to work as you said in recent kernels, though. So I am certainly
> missing something here.
>
I think I got it now. It's all based on the current->perf_event_ctxp.
So you only
look at the events (and thus sampling buffers) attached to current which issued
the mmap().

I found out that my problem is coming from perf creating synthetic
mmap() entries
for everything it finds in /proc/PID.
