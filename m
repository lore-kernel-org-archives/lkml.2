Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965023Ab2J3Rna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:43:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54033 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965080Ab2J3RnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:43:20 -0400
MIME-Version: 1.0
In-Reply-To: <1351613128.8467.109.camel@gandalf.local.home>
References: <CAFbHwiRtBaHkpZqTm6VZ=fCJcyu+dsdpo_kxMHy1egce=rTuyA@mail.gmail.com>
	<1351609517.8467.85.camel@gandalf.local.home>
	<CAFbHwiRXzWpKjtu2jQzr_COuSLg=HNit-CfkTuArrzc+xP53Og@mail.gmail.com>
	<1351613128.8467.109.camel@gandalf.local.home>
Date: Tue, 30 Oct 2012 17:43:19 +0000
Message-ID: <CAFbHwiSwGc8g7AV5mKic3JPDktFHw0pE7kR4yXRYoL_Jsyz6fQ@mail.gmail.com>
Subject: Re: [PATCH] scripts/recordmcount.pl: Support build with -ffunction-sections.
From: Will Newton <will.newton@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 4:05 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2012-10-30 at 15:35 +0000, Will Newton wrote:
>> On Tue, Oct 30, 2012 at 3:05 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > On Tue, 2012-10-30 at 14:51 +0000, Will Newton wrote:
>> >> Scan any text section whose name begins with ".text." so
>> >> we will find all the functions in a kernel built with
>> >> -ffunction-sections.
>> >
>> > A couple of things.
>> >
>> > First, I'm very paranoid about a blanket "ok" on sections. We must
>> > guarantee that all sections that starts with ".text" never is freed. And
>> > if it is freed, that it must inform ftrace that it's about to free it
>> > before it does. If we can not guarantee this, then we can't do it.
>>
>> I share that concern, however it looks like it should be safe.
>
> Can we confirm that it is safe. I'm not too confident with the words
> "looks like" ;-)

Ok, well we are only concerned with C compiled code, otherwise there
would be no calls to mcount? The only way I can think of to cause code
to be emitted in a section of this type is to use the section
attribute. A quick grep for __attribute__(__section__ or __section
does not turn up any sections that are named .text.* on any
architecture (freed or not).

Is there any other case I have missed? I also did a grep for .text.
more generally and didn't see anything that looked problematic
(although it is mainly .S files so not relevant).

>>
>> > Second, most archs today do not use recordmcount.pl. They use the new
>> > recordmcount.c file.
>>
>> Ok, thanks for letting me know. Is the plan to switch over to
>> recordmcount.c exclusively at some point?
>
> When all the archs convert.

I'll rework my patch against recordmcount.c once I have it working.
