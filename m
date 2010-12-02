Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab0LBUwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 15:52:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65043 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060Ab0LBUwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 15:52:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=XjWexPg2zdMwirT7JQ9cCT3S6sNhs4Bg58ho2SMImbKS1S4OrjAwFsDFKVaRxj9z93
         tk8ZOM8QTkmgLha5CpFJhyOojsfaV2iO6OYNUbeplXmjD1/juETtKelYrbQ7MLxLgMQI
         61d2dSEUYLM3P++4OFi9NHtYYSrA8riVHHoTc=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Francis Moreau <francis.moro@gmail.com>
Subject: Re: perf: some questions about perf software events
References: <m3tyj73qev.fsf@gmail.com> <1290598906.2072.461.camel@laptop>
	<m3oc9a520m.fsf@gmail.com> <1291157071.32004.1374.camel@laptop>
Date: Thu, 02 Dec 2010 21:52:18 +0100
In-Reply-To: <1291157071.32004.1374.camel@laptop> (Peter Zijlstra's message of
	"Tue, 30 Nov 2010 23:44:31 +0100")
Message-ID: <m3y687rj7h.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> On Sat, 2010-11-27 at 14:28 +0100, Franck Bui-Huu wrote:

[...]

>> 
>> Does it make sense to adjust the period for both of them ?
>> 
>> Also, when creating a task clock event, passing 'pid=-1' to
>> sys_perf_event_open() doesn't really make sense, does it ?
>> 
>> Same with cpu clock and 'pid=n': whatever <n> value, the event measure
>> the cpu wall time clock.
>> 
>> Perhaps proposing only one clock in the API and internally bind this
>> clock to the cpu or task clock depending on pid or cpu parameters would
>> have been better ?
>> 
>
> No, it actually makes sense to count both cpu and task clock on a task
> (cpu clock basically being wall-time).
>

But a task can create several instances of the same events, no ?

For HW events, they'll use counters that support the type of these
events and if there are not enough of them then those events will share
the counters in a round robin fashion.

For SW events, there's no limit at all.

So doing:

   attr.type   = PERF_TYPE_SOFTWARE;
   attr.config = PERF_COUNT_SW_ClOCK;
   /* ... */
   tsk_clock_fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
   cpu_clock_fd = sys_perf_event_open(&attr, -1, 0, -1, 0);

should be allowed.

No ?
-- 
		Franck
