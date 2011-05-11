Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab1EKPuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:50:23 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52014 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab1EKPuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:50:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Sjxp3JWWowP5AZL3i0QaxoPtDzql0wPJknWmOkWa1o4DEUzfRFxp9JOkkBA0/AP7mT
         2ZR7stPlxqmpoi4aqy9IllPkq9BIJbPqdUKcK6ma035nKxCF9t4mFIRD2Yib1lsau8Lw
         kr5UYXbA+TegYxETmgKZegyIecwitK3ja5rn8=
MIME-Version: 1.0
In-Reply-To: <1305125333.2914.229.camel@laptop>
References: <tip-99ee5315dac6211e972fa3f23bcc9a0343ff58c4@git.kernel.org>
 <1305109433.2914.208.camel@laptop> <BANLkTi=j6eSyyEdGgUeZhQLJVa+meK_W6A@mail.gmail.com>
 <1305121541.2914.213.camel@laptop> <BANLkTik5szBkinZEWySVjBKA5GF+6dn8Yg@mail.gmail.com>
 <1305122518.2914.224.camel@laptop> <BANLkTim5WzcrzSiqhwXrhDDwcxF=JTpZew@mail.gmail.com>
 <1305124250.2914.225.camel@laptop> <BANLkTimvqAY9hwHujUVoQhN2eZQz-MVhgg@mail.gmail.com>
 <1305125333.2914.229.camel@laptop>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 11 May 2011 16:53:59 +0200
Message-ID: <BANLkTi=aOsRs4iS_j41=NNESC2rgmwtpbg@mail.gmail.com>
Subject: Re: [tip:timers/core] timerfd: Allow timers to be cancelled when
 clock was set
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        johnstul@us.ibm.com, davidel@xmailserver.org, virtuoso@slind.org,
        tglx@linutronix.de, chris.friesen@genband.com, kirill@shutemov.name,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 16:48, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-05-11 at 16:32 +0200, Kay Sievers wrote:
>> On Wed, May 11, 2011 at 16:30, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Wed, 2011-05-11 at 16:22 +0200, Kay Sievers wrote:
>> >> On Wed, May 11, 2011 at 16:01, Peter Zijlstra <peterz@infradead.org> wrote:
>> >> > On Wed, 2011-05-11 at 15:52 +0200, Kay Sievers wrote:
>> >> >>
>> >> >> No, fixed time spans have never been a problem, and are not the
>> >> >> example here. It's about the normal wall clock, that wakes up every
>> >> >> minute and updates the numbers on the screen.
>> >> >
>> >> > 'wakes up every minute' sounds like a fixed time interval to me.
>> >>
>> >> Right, but if the wall clock changes, it must not wait for the full
>> >> minute to update the numbers, they need to update immediately with the
>> >> new wall clock time. Stuff woke up every second in the past to do
>> >> that, but that's not what we want today.
>> >
>> > Again, nothing that couldn't be solved with a notifier of sorts.
>>
>> Right. What we have with that patch, and what's visible to the
>> outside, is nothing but such a notifier. What kind of interface you
>> have in mind instead?
>
> Dunno, an eventfd that triggers every time someone calls adjtime() and
> related?

I think, we are exactly not interested in adjtime() calls, but only in
jumps in wall clock time.

Kay
