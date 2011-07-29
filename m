Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1G2TK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 15:10:56 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50230 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab1G2TKz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 15:10:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=VaHXPs8MhOygx1V6UvebY3vJ0t94yx4/3sM+zVM3uqHCHE35qyH8iQEqHkZ0m5vVd
	wBio79+IoI1WhxTgfH7Zg==
MIME-Version: 1.0
In-Reply-To: <1311963018.21143.73.camel@gandalf.stny.rr.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
 <1311721194-12164-3-git-send-email-vnagarnaik@google.com> <1311963018.21143.73.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 29 Jul 2011 12:10:20 -0700
Message-ID: <CAL26m8JtwE0DcEL3JUs+a_boWbiZAzEvUfvCQ_z5aob2935pVQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] trace: Add ring buffer stats to measure rate of events
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 11:10 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-07-26 at 15:59 -0700, Vaibhav Nagarnaik wrote:
>> The stats file under per_cpu folder provides the number of entries,
>> overruns and other statistics about the CPU ring buffer. However, the
>> numbers do not provide any indication of how full the ring buffer is in
>> bytes compared to the overall size in bytes. Also, it is helpful to know
>> the rate at which the cpu buffer is filling up.
>>
>> This patch adds an entry "bytes: " in printed stats for per_cpu ring
>> buffer which provides the actual bytes consumed in the ring buffer. This
>> field includes the number of bytes used by recorded events and the
>> padding bytes added when moving the tail pointer to next page.
>>
>> It also adds the following time stamps:
>> "head ts:" - the oldest timestamp in the ring buffer
>
>
> I hate the name of "head_ts", as it really is meaningless. The head of
> our ring buffer is indeed the oldest events, but other ring buffers have
> head as the newest. This is an internal name that should not be used
> outside of the ring buffer code itself. Maybe call it "oldest_ts", or
> even more verbose (and what it actually is), "oldest_event_ts".
>
>
>> "now ts:"  - the timestamp at the time of reading
>>
>> The field "now ts" provides a consistent time snapshot to the userspace
>> when being read. This is read from the same trace clock used by tracing
>> event timestamps.
>>
>> Together, these values provide the rate at which the buffer is filling
>> up, from the formula:
>> bytes / (now_ts - head_ts)
>>
>> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
>> ---
>
>>  /**
>> + * ring_buffer_head_ts - get the oldest event timestamp from the buffer
>> + * @buffer: The ring buffer
>> + * @cpu: The per CPU buffer to read from.
>> + */
>> +unsigned long ring_buffer_head_ts(struct ring_buffer *buffer, int cpu)
>
> Hence, replace head_ts, with something else here.
>
> Thanks,
>
> -- Steve
>

'oldest_event_ts' sounds good.


Vaibhav Nagarnaik
