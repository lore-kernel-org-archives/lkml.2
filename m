Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab2HFTnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:43:08 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41377 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab2HFTnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:43:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120806181941.GG21441@infradead.org>
References: <1344247319-304069-1-git-send-email-avagin@openvz.org>
	<1344247319-304069-3-git-send-email-avagin@openvz.org>
	<20120806181941.GG21441@infradead.org>
Date: Mon, 6 Aug 2012 23:43:04 +0400
Message-ID: <CANaxB-xq_wDGZQ16nTD6agwc_JiE4dQe1fXmvmPZckAX0EVr9w@mail.gmail.com>
Subject: Re: [PATCH 2/3] perf: teach perf inject to merge sched_stat_* and
 sched_switch events
From: Andrey Wagin <avagin@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnaldo,

Thanks for comments, I will correct them. I need a bit more details
about two of them.

2012/8/6 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
>> @@ -21,6 +23,9 @@ static int          output;
>>  static u64           bytes_written;
>>
>>  static bool          inject_build_ids;
>> +static bool          inject_sched_stat;
>> +
>> +struct perf_session  *session;

perf_event__sched_stat (perf_inject.sample) uses "session" for getting
an event name. I don't know how to get it by another way

>
> Why do we need to insert even more globals?
>
>>  static int perf_event__repipe_synth(struct perf_tool *tool __used,
>>                                   union perf_event *event,
>> @@ -47,7 +52,7 @@ static int perf_event__repipe_synth(struct perf_tool *tool __used,
>>
>>  static int perf_event__repipe_op2_synth(struct perf_tool *tool,
>>                                       union perf_event *event,
>> -                                     struct perf_session *session __used)
>> +                                     struct perf_session *s __used)
>
> What is the point of the above hunk?

"session" is global, for this reason I renamed all arguments.

p.s. Arnaldo, sorry for the personal message with the same content.
It's my mistake.
