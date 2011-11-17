Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab1KQIWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:22:22 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47378 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab1KQIWV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:22:21 -0500
MIME-Version: 1.0
In-Reply-To: <4EBCF0EB.8080304@gmail.com>
References: <1320670457-2633428-1-git-send-email-avagin@openvz.org>
	<1320670457-2633428-3-git-send-email-avagin@openvz.org>
	<1320839740.13360.11.camel@twins>
	<4EBCF0EB.8080304@gmail.com>
Date: Thu, 17 Nov 2011 11:22:20 +0300
Message-ID: <CANaxB-xOQr=gHGRwPUoZN7cMdss48Q5A2XJvU7Kg+MaCZeqX9w@mail.gmail.com>
Subject: Re: [PATCH 2/7] event: don't divide events if it has field period
From: Andrew Wagin <avagin@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Arun Sharma <asharma@fb.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, devel@openvz.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

11 ноября 2011 г. 13:54 пользователь Andrew Vagin <avagin@gmail.com> написал:
> On 11/09/2011 03:55 PM, Peter Zijlstra wrote:
>>
>> On Mon, 2011-11-07 at 15:54 +0300, Andrew Vagin wrote:
>>>
>>> This patch solves the following problem:
>>>
>>> Now some samples may be lost due to throttling. The number of samples is
>>> restricted by sysctl_perf_event_sample_rate/HZ.  A trace event is
>>> divided on some samples according to event's period.  I don't sure, that
>>> we should generate more than one sample on each trace event. I think the
>>> better way to use SAMPLE_PERIOD.
>>
>> It would be yes, but this code predates that, also it needs to work even
>> if the user doesn't provide SAMPLE_PERIOD.

I have not understood exactly what I should do now.
I'm going to send the third version of this patches. New version
contains only a small fix according with the comment for path 4/7.
In new version I am not going to fix the problem about which we
discussed early. I have some reasons for it:

*  It's another task. My decision is more effective for my task and  I
believe that exists many cases where my decision may be suitable. I
want to say, that it may be in kernel, event if the problem would not
exist at all.
* __perf_count() has been broken for a long time and nobody reports
this problem, so we can say, that the problem isn't urgent.
* Only few events sched:sched_stat_* are affected by this problem.
* I am not sure, that we should to solve this problem. The "problem"
may be not a problem at all. We have ability to customize
sample_period and we have events about that some events were
throttled.

If you have any objection, send them to me.
