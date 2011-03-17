Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab1CQSZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:25:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59850 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab1CQSZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LfjwkgG+zJc12oxsH6msvRiN2f/lBMG6mbInsEVgSeazTuBVyOhKSS0jhPXgp0aV7G
         +561YZSwrnMWjhabgjqRTlRsHMFIYux/Pi9kBgybPjDFnBIgLwPJIEyH/QRMnwJqpPgD
         PwxI1AiI5RA3bx7QNJpOOjDQO2oMxRHLiQQMQ=
MIME-Version: 1.0
In-Reply-To: <1300385802.16880.348.camel@gandalf.stny.rr.com>
References: <AANLkTi=e+tM-WTerLmkZfLTQqKCLsJHVBgQ5sj+TMjc4@mail.gmail.com>
	<1300370936.16880.96.camel@gandalf.stny.rr.com>
	<AANLkTi=Z_yYkdwzO7TMs7nSMOXR9wn_7BxtKjOKgS5HL@mail.gmail.com>
	<1300380909.16880.264.camel@gandalf.stny.rr.com>
	<1300381340.6315.323.camel@edumazet-laptop>
	<1300385802.16880.348.camel@gandalf.stny.rr.com>
Date: Thu, 17 Mar 2011 19:25:36 +0100
X-Google-Sender-Auth: 1sjvNT8TdDT_pmqjvcBbMeqx_e4
Message-ID: <AANLkTim4hY_HJrukNjVe5RDzBj7r547BcxKRozKcQ_uE@mail.gmail.com>
Subject: Re: um: WARNING: at kernel/futex.c:786 __unqueue_futex
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        laijs@cn.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net, dvhart@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 19:16, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2011-03-17 at 18:02 +0100, Eric Dumazet wrote:
>> Le jeudi 17 mars 2011 à 12:55 -0400, Steven Rostedt a écrit :
>> > Here, test this patch. I'm in the process of committing it now.
>> > It will be two patches, one for the WARN_ON_SMP() change, the other for
>> > the futex change.
>> >
>> > -- Steve
>> >
>> > diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
>> > index c2c9ba0..25f1e9e 100644
>> > --- a/include/asm-generic/bug.h
>> > +++ b/include/asm-generic/bug.h
>> > @@ -168,7 +168,7 @@ extern void warn_slowpath_null(const char *file, const int line);
>> >  #ifdef CONFIG_SMP
>> >  # define WARN_ON_SMP(x)                    WARN_ON(x)
>> >  #else
>> > -# define WARN_ON_SMP(x)                    do { } while (0)
>> > +# define WARN_ON_SMP(x)                    ({0;})
>> >  #endif
>> >
>>
>> You meant :
>>
>> # define WARN_ON_SMP(x)                       ({x;})
>>
>> or
>>
>> # define WARN_ON_SMP(x)         do { } while (x, 0)
>>
>> ?
>>
>
> Does if (do { } while (x, 0)) work?

No.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
