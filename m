Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab1EKQJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:09:44 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51844 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022Ab1EKQJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:09:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=OfjlaLwg24zkAAQ+WwnuVwCF3aYzCJAEoDa90uaPsSr+Qpae7r3Jk+XdzIJ1XoZ5jT
         4w1KzthrQGYJNsfSL2H1MRXBRbMRxjtewu3yAb2dOkN/zVhZk0kc39sDdno2RWI8E5iS
         y8DYKo9orOzH52NimtJ2YG8qenwnmudcpUpvI=
MIME-Version: 1.0
In-Reply-To: <1305124250.2914.225.camel@laptop>
References: <tip-99ee5315dac6211e972fa3f23bcc9a0343ff58c4@git.kernel.org>
 <1305109433.2914.208.camel@laptop> <BANLkTi=j6eSyyEdGgUeZhQLJVa+meK_W6A@mail.gmail.com>
 <1305121541.2914.213.camel@laptop> <BANLkTik5szBkinZEWySVjBKA5GF+6dn8Yg@mail.gmail.com>
 <1305122518.2914.224.camel@laptop> <BANLkTim5WzcrzSiqhwXrhDDwcxF=JTpZew@mail.gmail.com>
 <1305124250.2914.225.camel@laptop>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 11 May 2011 16:32:32 +0200
Message-ID: <BANLkTimvqAY9hwHujUVoQhN2eZQz-MVhgg@mail.gmail.com>
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

On Wed, May 11, 2011 at 16:30, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-05-11 at 16:22 +0200, Kay Sievers wrote:
>> On Wed, May 11, 2011 at 16:01, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Wed, 2011-05-11 at 15:52 +0200, Kay Sievers wrote:
>> >>
>> >> No, fixed time spans have never been a problem, and are not the
>> >> example here. It's about the normal wall clock, that wakes up every
>> >> minute and updates the numbers on the screen.
>> >
>> > 'wakes up every minute' sounds like a fixed time interval to me.
>>
>> Right, but if the wall clock changes, it must not wait for the full
>> minute to update the numbers, they need to update immediately with the
>> new wall clock time. Stuff woke up every second in the past to do
>> that, but that's not what we want today.
>
> Again, nothing that couldn't be solved with a notifier of sorts.

Right. What we have with that patch, and what's visible to the
outside, is nothing but such a notifier. What kind of interface you
have in mind instead?

Kay
