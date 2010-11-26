Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0KZJTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 04:19:39 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45336 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab0KZJTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 04:19:37 -0500
Date: Fri, 26 Nov 2010 09:18:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Olof Johansson <olof@lixom.net>, Hari Kanigeri <h-kanigeri2@ti.com>,
        Suman Anna <s-anna@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Kevin Hilman <khilman@deeprootsystems.com>, akpm@linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
Message-ID: <20101126091832.GE9310@n2100.arm.linux.org.uk>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com> <1290526740-27624-2-git-send-email-ohad@wizery.com> <20101126045912.GC6598@lixom.net> <AANLkTin5Tfcuy0WcHJ22rWC8niwZCj8SZAMKLz0p9jwc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin5Tfcuy0WcHJ22rWC8niwZCj8SZAMKLz0p9jwc@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 10:53:10AM +0200, Ohad Ben-Cohen wrote:
> >> +int __hwspin_trylock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
> >> +{
> >> +     int ret;
> >> +
> >> +     if (unlikely(!hwlock)) {
> >> +             pr_err("invalid hwlock\n");
> >
> > These kind of errors can get very spammy for buggy drivers.
> 
> Yeah, but that's the purpose - I want to catch such egregious drivers
> who try to crash the kernel.

That can be better - because you get a backtrace, and it causes people
to report the problem rather than just ignore it.  It may also prevent
the driver author releasing his code (as it won't work on their
initial testing.)

> > It's likely
> > more useful to either do a WARN_ON(), and/or move them under a debug
> > config option.
> 
> Why would you prefer to compile out reporting of such extremely buggy
> behavior ?

If it's "extremely buggy behaviour" then the drivers deserve to crash.
Such stuff should cause them not to get out the door.  A simple printk
with an error return can just be ignored.
