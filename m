Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab2JLCdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 22:33:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63755 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2JLCdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 22:33:42 -0400
MIME-Version: 1.0
In-Reply-To: <1350005812.24256.81.camel@gandalf.local.home>
References: <1349998076-15495-1-git-send-email-dhsharp@google.com>
 <1349998076-15495-7-git-send-email-dhsharp@google.com> <1350005812.24256.81.camel@gandalf.local.home>
From: David Sharp <dhsharp@google.com>
Date: Thu, 11 Oct 2012 19:33:19 -0700
Message-ID: <CAJL_ekv17ktQhewX-dJGYvHc0Q2xjxsRYfSdyAUCVuhTynKGZQ@mail.gmail.com>
Subject: Re: [PATCH v6 6/6] tracing: Fix maybe-uninitialized warning in ftrace_function_set_regexp
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 6:36 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2012-10-11 at 16:27 -0700, David Sharp wrote:
>> Compiler warning:
>>
>> kernel/trace/trace_events_filter.c: In function 'ftrace_function_set_filter_cb':
>> kernel/trace/trace_events_filter.c:2074:8: error: 'ret' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>>
>> Signed-off-by: David Sharp <dhsharp@google.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> ---
>>  kernel/trace/trace_events_filter.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
>> index 431dba8..ef36953 100644
>> --- a/kernel/trace/trace_events_filter.c
>> +++ b/kernel/trace/trace_events_filter.c
>> @@ -2002,9 +2002,10 @@ static int ftrace_function_set_regexp(struct ftrace_ops *ops, int filter,
>>  static int __ftrace_function_set_filter(int filter, char *buf, int len,
>>                                       struct function_filter_data *data)
>>  {
>> -     int i, re_cnt, ret;
>> +     int i, re_cnt;
>>       int *reset;
>>       char **re;
>> +     int ret = 0;
>>
>>       reset = filter ? &data->first_filter : &data->first_notrace;
>>
>
> It has already been fixed in mainline:
>
> 92d8d4a8b0f4c6eba70f6e62b48e38bd005a56e6
>
> http://marc.info/?l=linux-kernel&m=134012157512078

Okay, drop this one then. I haven't been rebasing.
