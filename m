Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1EKPqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:46:08 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56006 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab1EKPqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:46:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KhV1+N8gH8Az5wRLjCoKEESqy3pJ70olFXR6+zYF3Ryp+2gMSzoeJLMZMw3lw182ae
         Ps/U+BeaIO2Z95nGPNawdMgj58Mn2JyJT60UxuCv1xqnP6Sc+OaVsGRsx2ySHsj4UAa9
         sOrt/MiP0QvhBuRSMZegYlw/VDycvuL5t/lzg=
MIME-Version: 1.0
In-Reply-To: <1305121541.2914.213.camel@laptop>
References: <tip-99ee5315dac6211e972fa3f23bcc9a0343ff58c4@git.kernel.org>
 <1305109433.2914.208.camel@laptop> <BANLkTi=j6eSyyEdGgUeZhQLJVa+meK_W6A@mail.gmail.com>
 <1305121541.2914.213.camel@laptop>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 11 May 2011 15:52:14 +0200
Message-ID: <BANLkTik5szBkinZEWySVjBKA5GF+6dn8Yg@mail.gmail.com>
Subject: Re: [tip:timers/core] timerfd: Allow timers to be cancelled when
 clock was set
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        johnstul@us.ibm.com, davidel@xmailserver.org, virtuoso@slind.org,
        tglx@linutronix.de, chris.friesen@genband.com, kirill@shutemov.name,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 15:45, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-05-11 at 13:58 +0200, Kay Sievers wrote:
>> On Wed, May 11, 2011 at 12:23, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Mon, 2011-05-02 at 19:44 +0000, tip-bot for Thomas Gleixner wrote:
>> >> Commit-ID:  99ee5315dac6211e972fa3f23bcc9a0343ff58c4
>> >> Gitweb:     http://git.kernel.org/tip/99ee5315dac6211e972fa3f23bcc9a0343ff58c4
>> >> Author:     Thomas Gleixner <tglx@linutronix.de>
>> >> AuthorDate: Wed, 27 Apr 2011 14:16:42 +0200
>> >> Committer:  Thomas Gleixner <tglx@linutronix.de>
>> >> CommitDate: Mon, 2 May 2011 21:39:15 +0200
>> >>
>> >> timerfd: Allow timers to be cancelled when clock was set
>> >>
>> >> Some applications must be aware of clock realtime being set
>> >> backward. A simple example is a clock applet which arms a timer for
>> >> the next minute display. If clock realtime is set backward then the
>> >> applet displays a stale time for the amount of time which the clock
>> >> was set backwards. Due to that applications poll the time because we
>> >> don't have an interface.
>> >
>> > Shouldn't that clock applet use CLOCK_MONOTONIC for the timer anyway?
>>
>> Like: Hey let's meet at the bar 5 hours after bootup? :)
>
> Uhm, the example was a timer to update the displayed time, so a timer
> like: wake me next minute, suffices.

No, fixed time spans have never been a problem, and are not the
example here. It's about the normal wall clock, that wakes up every
minute and updates the numbers on the screen.

Kay
