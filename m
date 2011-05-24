Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab1EXO0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:26:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44287 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab1EXO0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sIDW3ptoTHQXsaAJY0/EZk/V2JswstjbScJp5vwo6iwfXjGETYxL0tuEAm48BktJHI
         ZJ00Z9j37j+LsXivaVHLZL1SGWMz1jbFHI3KEkHeguPqsBwzed6O7oGDu/7bMK6NT0tF
         X8CE+IlEuICUW5+VD9vVNkaHdyMGE8RT4OaU8=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1105241615080.7986@swampdragon.chaosbits.net>
References: <BANLkTimxmWiof9s5AvS3v_0X+sMiE=0x5g@mail.gmail.com>
	<BANLkTikhvhptDG-eRZ9uD5wSm3RxTn1RFw@mail.gmail.com>
	<1306238014.16375.0.camel@marge.simson.net>
	<BANLkTimq31hMRa+vD=pLrtTAx=Hv=h0Acg@mail.gmail.com>
	<alpine.LNX.2.00.1105241615080.7986@swampdragon.chaosbits.net>
Date: Tue, 24 May 2011 22:26:33 +0800
Message-ID: <BANLkTikamnMuuyG_CZJ+jv-kA7mPLNw1tg@mail.gmail.com>
Subject: Re: [PATCH] sched: remove noop in next_prio()
From: Hillf Danton <dhillf@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:16 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Tue, 24 May 2011, Hillf Danton wrote:
>
>> On Tue, May 24, 2011 at 7:53 PM, Mike Galbraith <efault@gmx.de> wrote:
>> > On Tue, 2011-05-24 at 16:17 +0800, Yong Zhang wrote:
>> >> On Sat, May 21, 2011 at 10:19 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> >> > When computing the next priority for a given run-queue, the check for
>> >> > RT priority of the task determined by the pick_next_highest_task_rt()
>> >> > function could be removed, since only RT task is returned by the
>> >> > function.
>> >> >
>> >> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> >>
>> >> Yup, it's true.
>> >
>> > (could whack the else while there)
>> >
>>
>> Where is it, Mike?
>>
>
>
> -       if (next && rt_prio(next->prio))
> +       if (next)
>               return next->prio;
> -       else
> -              return MAX_RT_PRIO;
> +       return MAX_RT_PRIO;
>
>
>
> --
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
>
>

Very cool, thank you:)

Hillf
