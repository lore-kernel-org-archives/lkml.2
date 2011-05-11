Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab1EKP7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:59:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:54151 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab1EKP7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:59:00 -0400
Subject: Re: [tip:timers/core] timerfd: Allow timers to be cancelled when
 clock was set
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        johnstul@us.ibm.com, davidel@xmailserver.org, virtuoso@slind.org,
        tglx@linutronix.de, chris.friesen@genband.com, kirill@shutemov.name,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <BANLkTi=j6eSyyEdGgUeZhQLJVa+meK_W6A@mail.gmail.com>
References: <tip-99ee5315dac6211e972fa3f23bcc9a0343ff58c4@git.kernel.org>
	 <1305109433.2914.208.camel@laptop>
	 <BANLkTi=j6eSyyEdGgUeZhQLJVa+meK_W6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 15:45:41 +0200
Message-ID: <1305121541.2914.213.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 13:58 +0200, Kay Sievers wrote:
> On Wed, May 11, 2011 at 12:23, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2011-05-02 at 19:44 +0000, tip-bot for Thomas Gleixner wrote:
> >> Commit-ID:  99ee5315dac6211e972fa3f23bcc9a0343ff58c4
> >> Gitweb:     http://git.kernel.org/tip/99ee5315dac6211e972fa3f23bcc9a0343ff58c4
> >> Author:     Thomas Gleixner <tglx@linutronix.de>
> >> AuthorDate: Wed, 27 Apr 2011 14:16:42 +0200
> >> Committer:  Thomas Gleixner <tglx@linutronix.de>
> >> CommitDate: Mon, 2 May 2011 21:39:15 +0200
> >>
> >> timerfd: Allow timers to be cancelled when clock was set
> >>
> >> Some applications must be aware of clock realtime being set
> >> backward. A simple example is a clock applet which arms a timer for
> >> the next minute display. If clock realtime is set backward then the
> >> applet displays a stale time for the amount of time which the clock
> >> was set backwards. Due to that applications poll the time because we
> >> don't have an interface.
> >
> > Shouldn't that clock applet use CLOCK_MONOTONIC for the timer anyway?
> 
> Like: Hey let's meet at the bar 5 hours after bootup? :)

Uhm, the example was a timer to update the displayed time, so a timer
like: wake me next minute, suffices.

The whole what to do with appointments when switching timezones wasn't
mentioned, but that too should be able to be sorted with a clkadjust
notifier.

