Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab2BTTjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:39:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63205 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab2BTTjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:39:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of avagin@gmail.com designates 10.204.151.196 as permitted sender) smtp.mail=avagin@gmail.com; dkim=pass header.i=avagin@gmail.com
Message-ID: <4F42A158.4090501@gmail.com>
Date: Mon, 20 Feb 2012 23:39:04 +0400
From: "avagin@gmail.com" <avagin@gmail.com>
Reply-To: avagin@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] trace: don't print an extra separator of flags
References: <1329650167-480655-1-git-send-email-avagin@openvz.org> <1329761354.25686.32.camel@gandalf.stny.rr.com>
In-Reply-To: <1329761354.25686.32.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 10:09 PM, Steven Rostedt wrote:
> On Sun, 2012-02-19 at 14:16 +0300, Andrew Vagin wrote:
>> From: Andrey Vagin<avagin@openvz.org>
>>
>> It occurs if __print_flags is used more than once
>
> Hi, which tracepoint does this? I like to see what the issue is.

The mainstream kernel doesn't have such trace-point, but I have.

Do you want to say that this bug should not be fixed in this case? :)

>
> Thanks,
>
> -- Steve
>
>>
>> Signed-off-by: Andrew Vagin<avagin@openvz.org>
>> ---
>>   kernel/trace/trace_output.c |    6 ++++--
>>   1 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
>> index 0d6ff35..3efd718 100644
>> --- a/kernel/trace/trace_output.c
>> +++ b/kernel/trace/trace_output.c
>> @@ -300,7 +300,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
>>   	unsigned long mask;
>>   	const char *str;
>>   	const char *ret = p->buffer + p->len;
>> -	int i;
>> +	int i, first = 1;
>>
>>   	for (i = 0;  flag_array[i].name&&  flags; i++) {
>>
>> @@ -310,8 +310,10 @@ ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
>>
>>   		str = flag_array[i].name;
>>   		flags&= ~mask;
>> -		if (p->len&&  delim)
>> +		if (!first&&  delim)
>>   			trace_seq_puts(p, delim);
>> +		else
>> +			first = 0;
>>   		trace_seq_puts(p, str);
>>   	}
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

