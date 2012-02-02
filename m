Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2BBIoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 03:44:16 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46283 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab2BBIoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 03:44:14 -0500
Date: Thu, 2 Feb 2012 08:43:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: TAO HU <tghk48@motorola.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-omap <linux-omap@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: In many cases softlockup can not be reported after disabling
	IRQ for long time
Message-ID: <20120202084350.GB1275@n2100.arm.linux.org.uk>
References: <CAOwKts8zS1rYA+Y4k-vb8YAaR=aFd1BwryhhWWnWLQyrYrNqyA@mail.gmail.com> <20120131154748.GA5650@redhat.com> <CAOwKts_dTvc4LiCZUXN9oYzty1pkDEn_VQwPKY=EoVzk0n6tFA@mail.gmail.com> <20120201145802.GF5650@redhat.com> <CAOwKts8S0EkUGcP3rYqZe+HdvyXD0+SR1f_3xWpu5FprKWuGhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOwKts8S0EkUGcP3rYqZe+HdvyXD0+SR1f_3xWpu5FprKWuGhQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.sdrawkcab esra s'ti ,tsop pot t'noD

(Don't top post, it's arse backwards.)

On Thu, Feb 02, 2012 at 04:17:02PM +0800, TAO HU wrote:
> My concern is not actually that the softlockup could not be reported
> while the IRQ is disabled.
> What bothering me is that even AFTER re-enable the IRQ, it will not
> give warning in many cases.

That's already been explained.

softlockups are detected by time passing.  Time can't properly advance
with interrupts disabled, as the backing counter (assuming you're using
the clocksource and clockevent stuff) could wrap.  If it wraps, the
systems idea of time which has passed will be incorrect.

So, if interrupts are disabled for a long period, the system loses track
of time, and therefore can't know how long the system has been blocked for.
