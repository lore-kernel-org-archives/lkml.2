Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0KBUvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 16:51:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38057 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab0KBUvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 16:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Cts6AdKd9XTOt0KzhaptTDn3aesydjo1fyXE/UQ11QjNM7VQjrTrk7+8OnqyiRHNee
         HDO+IVUdckvigYUy+T4UOqlOfN0TJPwdzLkyAWF3hCiecJr9uXadlMTcdE9Y6RZ3hirl
         Wl1poB+Bxb5KUb3rTGKzp1gyHh/+uf+M03fSw=
MIME-Version: 1.0
In-Reply-To: <20100805145940.GA8685@zhy>
References: <AANLkTi=gnsPUPomCUXRLgV0PhNxtBaXiCheDU=yRV0Kx@mail.gmail.com>
	<1280995849.1923.1515.camel@laptop>
	<20100805145940.GA8685@zhy>
Date: Wed, 3 Nov 2010 06:51:07 +1000
Message-ID: <AANLkTik68yb2JUL14tnzWfyT1J_50LqFmTs8AdDvC+4p@mail.gmail.com>
Subject: Re: lockdep and oops_in_progress
From: Dave Airlie <airlied@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 12:59 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Thu, Aug 05, 2010 at 10:10:49AM +0200, Peter Zijlstra wrote:
>> On Thu, 2010-08-05 at 16:21 +1000, Dave Airlie wrote:
>> > Hi guys,
>> >
>> > I was debugging a wierd issue with suspend/resume and fbcon/X with
>> > some recent work Jesse and myself did to try and make sure a pinned
>> > fbcon always gets the text on it with a panic or oops occurs.
>> >
>> > It does this by testing the oops_in_progress flag, however once any
>> > lockdep issue occurs it looks to me that we leave this flag set
>> > forever, in most places I can see in oops code etc they call
>> > bust_spinlocks(1) then bust_spinlocks(0) to balance the
>> > oops_in_progress value, but lockdep never seems to reset it.
>> >
>> > I'm wondering if there is an inherent reason for this or if I whip up
>> > a patch to reset once the lockdep is printed if this would cause any
>> > issues?
>>
>> That's debug_locks_off(), right? I don't think there's a particular
>> reason we keep it set, cleaning that up might take a bit of work but
>> shouldn't be too hard.
>
> commit e0fdace10e75dac67d906213b780ff1b1a4cc360
> Author: David Miller <davem@davemloft.net>
> Date:   Fri Aug 1 01:11:22 2008 -0700
>
>    debug_locks: set oops_in_progress if we will log messages.
>
>    Otherwise lock debugging messages on runqueue locks can deadlock the
>    system due to the wakeups performed by printk().
>
>    Signed-off-by: David S. Miller <davem@davemloft.net>
>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> Seems we can revert that commit now because of 'robustify printk'.
>
> Dave, what do you think about it?

Hey DaveM, as mentioned at KS,

Dave.
