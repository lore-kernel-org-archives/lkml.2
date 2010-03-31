Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab0CaEBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 00:01:14 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54488 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab0CaEBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 00:01:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=dOljEyyHVgMSf/t1HuBseA2R7vuov7ByXL0hpbXw2qOOeamsCFtoT0DiJ2ZCKvpQU
	nUs40tryL1VTdZwsDKrEg==
MIME-Version: 1.0
In-Reply-To: <1269995724.22564.58.camel@localhost.localdomain>
References: <m2u5df78e1d1003301627ya1f621f7qaf0ad099f62d787e@mail.gmail.com>
	 <1269995724.22564.58.camel@localhost.localdomain>
Date: Tue, 30 Mar 2010 21:01:08 -0700
Message-ID: <q2o5df78e1d1003302101q585143aan32e8872fcdb05c8a@mail.gmail.com>
Subject: Re: lockup in rb_get_reader_page
From: Jiaying Zhang <jiayingz@google.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Michael Rubin <mrubin@google.com>,
       David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot for your quick reply!

On Tue, Mar 30, 2010 at 5:35 PM, Steven Rostedt <srostedt@redhat.com> wrote:
> Hi Jiaying,
>
>
> On Tue, 2010-03-30 at 16:27 -0700, Jiaying Zhang wrote:
>> Hi Steven,
>>
>> We recently saw some cpu lockups while running kernel tracing.
>> The problem started to happen after we synced up our ring buffer
>> code with the upstream lockless ring buffer change. It usually
>> took many hours and heavy trace load to hit this problem. When
>> the lockup happens, the problematic cpu seemed to be in an infinite
>> loop of trying to grab the head_page in rb_get_reader_page().
>>
>> We would like to check with you on whether this is a known issue.
>> If so, do we have a bug fix? If not, do you have any suggestions on
>> where we should check?
>
> I'm unaware of any problems with the ring buffer. I've been running the
> lockless version for over a year now, and hammering it with very
> intensive tracing.
>
> Now, you see this on the reader side. There has been a few recent fixes
> that could cause problems when we have multiple readers. Ftrace usage
> does not usually encounter multiple readers so I have not had issues.
> But Li Zefan had a stress test that did find and trigger the problems.
>
I looked at Li Zefan's patch but I think that is to fix a lockup issue in
ftrace. We are not using ftrace right now but still use our own kernel
trace wrapper built on top of ring buffer. We also only use one reader.
I guess it is more likely a race between trace reader and trace writer.

> Are you using the latest ring buffer that is in Linus's tree? Are you
> resetting the ring buffer while reading it?
>
No. We don't allow resetting buffer when there is any active reader.
I don't think we ever reset the ring buffer on those machines that hit
this problem.

> I guess I need to know more exactly what you are doing to understand the
> problem.
>
I am going to patch rb_get_reader_page() to print out some debugging
message when it enters into an infinitely loop. I will keep you updated
if I find any interesting info.

Thanks a lot!

Jiaying

> Thanks,
>
> -- Steve
>
>
>
