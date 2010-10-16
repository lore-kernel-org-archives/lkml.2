Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab0JPQcn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:32:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43839 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab0JPQcm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:32:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MK64wvIztwUA333FWnEuA4ig/pRQPJM/ZScMoiy1KM9PrkjtPJ9kP/Si3pKEyKVEHN
         ynQH14kSHIVxVvwOg0Aez5w5qfNCFjTXdmLVgAeivzj9yFwl1RKW8+5klah2+y5ORj0b
         lgsPN7qWtDxhhu5+rV+Xa2O16inSmJsRTzOCg=
MIME-Version: 1.0
In-Reply-To: <20101016161627.GA3567@elte.hu>
References: <20101016131505.GW14064@sgi.com>
	<20101016144529.GA5384@nowhere>
	<1287242272.16971.53.camel@gandalf.stny.rr.com>
	<20101016161627.GA3567@elte.hu>
Date: Sat, 16 Oct 2010 18:32:40 +0200
X-Google-Sender-Auth: tiA990UvQftvzNlRxMhZ7lQB85k
Message-ID: <AANLkTik4J=tWtdcCogfLqeFwnP_YkORfkntR8rg7NGBc@mail.gmail.com>
Subject: Re: ftrace does not work on cpus > 999.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Robin Holt <holt@sgi.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 18:16, Ingo Molnar <mingo@elte.hu> wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> On Sat, 2010-10-16 at 16:45 +0200, Frederic Weisbecker wrote:
>>
>> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> > index 9ec59f5..3565f9e 100644
>> > --- a/kernel/trace/trace.c
>> > +++ b/kernel/trace/trace.c
>> > @@ -3999,7 +3999,7 @@ static void tracing_init_debugfs_percpu(long cpu)
>> >     /* strlen(cpu) + MAX(log10(cpu)) + '\0' */
>> >     char cpu_dir[7];
>> >
>> > -   if (cpu > 999 || cpu < 0)
>> > +   if (cpu < 0)
>> >             return;
>> >
>> >     sprintf(cpu_dir, "cpu%ld", cpu);
>>
>> You need to change the size of cpu_dir, otherwise this will overflow.
>
> If you change it to 30 that ought to be enough, as long as cpu_id's fit

Yep.

> into u64. (I think we wont overflow that in my lifetime.)

>> The other case is to dynamically allocate cpu_dir.
>
> Please tell me that is a joke ...

And if it isn't, use kasprintf() ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
