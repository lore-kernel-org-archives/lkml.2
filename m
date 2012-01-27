Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab2A0TVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 14:21:41 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49903 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154Ab2A0TVj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 14:21:39 -0500
MIME-Version: 1.0
In-Reply-To: <1327635873.22710.113.camel@gandalf.stny.rr.com>
References: <1327633215-4013-1-git-send-email-dhsharp@google.com> <1327635873.22710.113.camel@gandalf.stny.rr.com>
From: David Sharp <dhsharp@google.com>
Date: Fri, 27 Jan 2012 11:21:18 -0800
Message-ID: <CAJL_eksfxza82jy62NUPmZGtQ77LVuHk+RnN3F95s-hSaSpK2w@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: fix length calculation for padding events
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com, chavey@google.com,
        Gregory Haskins <gregory.haskins@gmail.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 7:44 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2012-01-26 at 19:00 -0800, David Sharp wrote:
>> Padding events store size in bytes, not words. Usually this ends up pushing
>> the parser off the current page, but occasionally not, and when not,
>> it ends up desynchronizing the parser from the event stream. This would
>> manifest as a lot of "ug!" messages from trace-cmd, and kernelshark
>> crashing before displaying the UI.
>>
>
> Nice! Funny, Gregory (Cc'd) sent me a trace.dat file that exhibited this
> behavior. I was going to look into it tomorrow. I tried it with this
> patch and it makes the bug go away.
>
> Nice catch!  I wonder how long this has been around without notice?
> Probably from day one.

Yeah, I think so. It's an easy mistake to make, because it's
incongruent with the rest of the event types.

>
> -- Steve
>
>> Signed-off-by: David Sharp <dhsharp@google.com>
>> ---
>>  trace-input.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/trace-input.c b/trace-input.c
>> index e3157a7..b6af1e6 100644
>> --- a/trace-input.c
>> +++ b/trace-input.c
>> @@ -1458,7 +1458,6 @@ translate_data(struct pevent *pevent,
>>       switch (type_len) {
>>       case RINGBUF_TYPE_PADDING:
>>               *length = data2host4(pevent, *ptr);
>> -             *length *= 4;
>>               *ptr += *length;
>>               break;
>>
>
>
