Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1G2TJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 15:09:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24255 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab1G2TJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 15:09:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=vSuWBq6Ik3Q7tVDRNK+AQi4l/ZLIH5NtXrsmoQHUzoWE4FbJ8YdL7cVZfOhzNmpJz
	gALOIGSk/bKnCGx9UuHcg==
MIME-Version: 1.0
In-Reply-To: <1311962463.21143.70.camel@gandalf.stny.rr.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
 <1311721194-12164-2-git-send-email-vnagarnaik@google.com> <1311962463.21143.70.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 29 Jul 2011 12:09:12 -0700
Message-ID: <CAL26m8KzZ_=pDU0S2yAXeZ-obH8DDMq=hNdHJF86Jg+CXXoGnA@mail.gmail.com>
Subject: Re: [PATCH 1/5] trace: Add a new readonly entry to report total
 buffer size
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

On Fri, Jul 29, 2011 at 11:01 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-07-26 at 15:59 -0700, Vaibhav Nagarnaik wrote:
>> The current file "buffer_size_kb" reports the size of per-cpu buffer and
>> not the overall memory allocated which could be misleading. A new file
>> "buffer_total_size_kb" adds up all the enabled CPU buffer sizes and
>> reports it. This is only a readonly entry.
>>
>> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
>> ---
>>  kernel/trace/trace.c |   27 +++++++++++++++++++++++++++
>>  1 files changed, 27 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index e5df02c..ce57c55 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -3569,6 +3569,24 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
>>  }
>>
>>  static ssize_t
>> +tracing_total_entries_read(struct file *filp, char __user *ubuf,
>> +                             size_t cnt, loff_t *ppos)
>> +{
>> +     struct trace_array *tr = filp->private_data;
>> +     char buf[64];
>> +     int r, cpu;
>> +     unsigned long size = 0;
>> +
>> +     mutex_lock(&trace_types_lock);
>> +     for_each_tracing_cpu(cpu)
>> +             size += tr->entries >> 10;
>
> Could you make this consistent with buffer_size_kb as well. That is, if
> the buffer is "shrunk", could you have the expanded size printed as
> well.
>
> Thanks,
>
> -- Steve
>

Sure. I forgot about that.


Vaibhav Nagarnaik
