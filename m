Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab1AaNwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:52:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab1AaNwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:52:20 -0500
Date: Mon, 31 Jan 2011 08:52:18 -0500
From: Don Zickus <dzickus@redhat.com>
To: Sebastian =?iso-8859-1?Q?F=E4rber?= <faerber@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hard LOCKUP with 2.6.32.28 (maybe scheduler/tick related?)
Message-ID: <20110131135218.GA12173@redhat.com>
References: <AANLkTikk7ZyMFKTP=WuZR5QhJoEdmpCRy9BW=FiE160z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikk7ZyMFKTP=WuZR5QhJoEdmpCRy9BW=FiE160z@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 12:05:58PM +0100, Sebastian Färber wrote:
> Hi,
> 
> i recently upgraded some servers from 2.6.32.9 to 2.6.32.28 and see
> frequent "hard lockups" on
> a few of them now. I've compiled a kernel with debugging support and
> enabled the "NMI Watchdog"
> to get more information.
> I've attached my .config and the stack traces from the nmi watchdog,
> captured via a serial console.
> To me it looks like there is some problem in run_posix_cpu_timers and
> the problem is also
> triggering WARNING: at kernel/sched_fair.c:979 hrtick_start_fair.
> 
> Note that the kernel is patched with grsecurity and i'm running CONFIG_NO_HZ.
> There were no problems with 2.6.32.9.
> Would be great if someone could have a look at this, i can provide
> more information if neccessary.

Your attached 'crash' details had another stacktrace first.  That one
shows the nmi_watchdog triggering because a spin_lock is spinning forever
in 'd_real_path'.  I couldn't find that code in any upstream tree, then
again I was too lazy to clone the stable trees.  So I don't know what the
exact problem is, but if you look through the git history of 2.6.32.28 and
revert things that relate to 'd_real_path', you can probably workaround
the problem for now, until someone who knows that stuff better than me can
give you a better answer.

Cheers,
Don
