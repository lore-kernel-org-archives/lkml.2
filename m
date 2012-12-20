Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab2LTTSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:18:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab2LTTSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:18:05 -0500
Date: Thu, 20 Dec 2012 14:17:53 -0500
From: Don Zickus <dzickus@redhat.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Norbert Warmuth <nwarmuth@t-online.de>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RESEND][PATCH v3] watchdog: Fix disable/enable regression
Message-ID: <20121220191752.GR88797@redhat.com>
References: <87y5h1c70y.fsf@nemi.mork.no>
 <1355946691-7969-1-git-send-email-bjorn@mork.no>
 <20121219201336.GK88797@redhat.com>
 <874njh7nd5.fsf@nemi.mork.no>
 <87zk1967jn.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zk1967jn.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 10:44:44PM +0100, Bjørn Mork wrote:
> Bjørn Mork <bjorn@mork.no> writes:
> > Don Zickus <dzickus@redhat.com> writes:
> >
> >> What about the opposite cases?  
> >> nmi_watchdog=1
> >> echo 1 > /sys/devices/system/cpu/cpu1/online
> >
> > I don't see why not. But verifying it would be nice.  I thought that it
> > would be a simple thing to test using qemu-kvm, but it seems that the
> > CPU hotplugging support there isn't quite ready. The guest just dies
> > with "Assertion `bus->allow_hotplug' failed."
> >
> > I'll go digging for alternatives, but if anyone else could verify this
> > then I'd appreciate it.
> 
> I just realized that you might not really want/need hotplugging, but
> just booting with some cores initially offline?

Actually, I did a poor job explaining myself but your previous email
answered my question.

The original problem was that hrtimer_cancel was being called on an
un-initialized object.  I was wondering what happens if watchdog_enable
was called multiple times, would it re-initialize a new object causing a
memory leak?

But as you pointed out that couldn't happen.

So I am fine with your changes.  Thanks for the initial and follow up
testing.

Acked-by: Don Zickus <dzickus@redhat.com>
