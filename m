Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0KZWyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 17:54:15 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53802 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab0KZWyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 17:54:15 -0500
Date: Fri, 26 Nov 2010 22:53:39 +0000
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
Message-ID: <20101126225339.GA26864@n2100.arm.linux.org.uk>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com> <1290526740-27624-2-git-send-email-ohad@wizery.com> <20101126045912.GC6598@lixom.net> <AANLkTin5Tfcuy0WcHJ22rWC8niwZCj8SZAMKLz0p9jwc@mail.gmail.com> <20101126091832.GE9310@n2100.arm.linux.org.uk> <AANLkTimS-cSi1B5LdtwhJWhKDuFKOYG1j_p-iQiH=zRe@mail.gmail.com> <20101126104548.GG9310@n2100.arm.linux.org.uk> <AANLkTi=h3gPN63NKKJ4wjumKNx9qDtxCKvOSbtRkr1wx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=h3gPN63NKKJ4wjumKNx9qDtxCKvOSbtRkr1wx@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 12:18:55AM +0200, Ohad Ben-Cohen wrote:
> But then there's the other (quite reasonable) claim that says we
> shouldn't crash the machine because of a non fatal bug: if a crappy
> driver messes up, the user (not the developer) will most probably
> prefer the machine to keep running with degraded functionality rather
> than boot.

There's also the quite reasonable expectation that we shouldn't corrupt
user data.  With locking interfaces, if someone abuses them and they
fail to work, then the risk is data corruption due to races.  The safe
thing in that case is to panic - terminate that thread before it does
anything unsafe, thereby preventing data corruption.

Yes, it may mean that something becomes unavailable, but that's better
than corrupting data.

Take a look at the kernel's own spinlock implementation.  Do we do lots
of checks in there for things like someone passing a NULL pointer to
the spinlock, or do we get an oops instead?

Also look at the list implementation.  Do we check for NULL pointers
there, or do we get an oops instead?

Same for mutex.  The same goes for lots of other infrastructure interfaces.
