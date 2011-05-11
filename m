Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab1EKQTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:19:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58844 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474Ab1EKQTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:19:01 -0400
Subject: Re: [tip:timers/core] timerfd: Allow timers to be cancelled when
 clock was set
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        kay.sievers@vrfy.org, johnstul@us.ibm.com, davidel@xmailserver.org,
        virtuoso@slind.org, tglx@linutronix.de, chris.friesen@genband.com,
        kirill@shutemov.name
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-99ee5315dac6211e972fa3f23bcc9a0343ff58c4@git.kernel.org>
References: <tip-99ee5315dac6211e972fa3f23bcc9a0343ff58c4@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 12:23:53 +0200
Message-ID: <1305109433.2914.208.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 19:44 +0000, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  99ee5315dac6211e972fa3f23bcc9a0343ff58c4
> Gitweb:     http://git.kernel.org/tip/99ee5315dac6211e972fa3f23bcc9a0343ff58c4
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Wed, 27 Apr 2011 14:16:42 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Mon, 2 May 2011 21:39:15 +0200
> 
> timerfd: Allow timers to be cancelled when clock was set
> 
> Some applications must be aware of clock realtime being set
> backward. A simple example is a clock applet which arms a timer for
> the next minute display. If clock realtime is set backward then the
> applet displays a stale time for the amount of time which the clock
> was set backwards. Due to that applications poll the time because we
> don't have an interface.

Shouldn't that clock applet use CLOCK_MONOTONIC for the timer anyway?

Furthermore, weren't there patches to provide clkadjust notifiers? In
which case we can have the app woken up and it can fiddle its own
timers.

> Extend the timerfd interface by adding a flag which puts the timer
> onto a different internal realtime clock. All timers on this clock are
> expired whenever the clock was set.

I don't much like adding random clocks like that, the extra timer base
makes many timer operations more expensive, and I really don't see this
being worth it :/

