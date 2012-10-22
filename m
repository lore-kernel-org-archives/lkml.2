Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab2JVXQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 19:16:21 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40676 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2JVXQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 19:16:20 -0400
MIME-Version: 1.0
In-Reply-To: <2097144.LhjfvZ65DK@vostro.rjw.lan>
References: <CAK5ve-JAc2Env1AyZMY178QobhqmAh4euHQdPS=UH3mGGeSgLA@mail.gmail.com>
 <CAK5ve-Lm6T0u08ZV+kw5+X_JUAoXksoPcxBo9FKAqQgdp6RRLA@mail.gmail.com>
 <CAK5ve-KDqi0HwE8upAmRmZUPcs=wgid_9QkQNksSGFUkWdEi+Q@mail.gmail.com> <2097144.LhjfvZ65DK@vostro.rjw.lan>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 22 Oct 2012 16:15:58 -0700
Message-ID: <CAK5ve-L=sRNGYxsEjuJZrPYszLAgBXEfPfkLnLdHmxfnyCRnDA@mail.gmail.com>
Subject: Re: [PATCH] ledtrig-cpu: use spin_lock to replace mutex lock
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Miles Lane <miles.lane@gmail.com>, akpm <akpm@linux-foundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 3:38 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday 22 of October 2012 11:59:19 Bryan Wu wrote:
>> Hiya,
>>
>> Can I get some Acked or Tested-by from Rafael or Miles before I put it
>> in my linux-leds tree?
>
> Well, I just explained why the current code didn't work. :-)
>
> Anyway, please feel free to add
>
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
>

I was just reminded by Nathan Lynch <ntl@pobox.com> most of
led-trigger API like register/unregister/event are potentially sleep.
They should not be used in atomic context. Any suggestion to fix it?

Thanks,
-Bryan

>
>> On Thu, Oct 18, 2012 at 12:34 PM, Bryan Wu <cooloney@gmail.com> wrote:
>> > On Thu, Oct 18, 2012 at 11:35 AM, Linus Walleij
>> > <linus.walleij@linaro.org> wrote:
>> >> On Thu, Oct 18, 2012 at 8:18 PM, Bryan Wu <cooloney@gmail.com> wrote:
>> >>
>> >>> Mutex lock is not safe in atomic context like the bug reported by
>> >>> Miles Lane:
>> >> (...)
>> >>> This patch replace mutex lock with spin lock which is safe for this case.
>> >>>
>> >>> Reported-by: Miles Lane <miles.lane@gmail.com>
>> >>> Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
>> >>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> >>> Signed-off-by: Bryan Wu <cooloney@gmail.com>
>> >>
>> >> Looks correct to me:
>> >> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> >>
>> >
>> > Thanks, Linus.
>> >
>> > Miles, could you please help to try this patch on your testing system?
>> > I really appreciate it.
>> >
>> > -Bryan
>>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
