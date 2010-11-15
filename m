Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0KOKGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:06:20 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47030 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab0KOKGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:06:19 -0500
Date: Mon, 15 Nov 2010 10:06:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Atul Sowani <sowani@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com,
        ralf@linux-mips.org
Subject: Re: [PATCH 2.6.36 1/1 RESEND] kernel SPIN_LOCK_UNLOCKED changed to
	__SPIN_LOCK_UNLOCKED()
Message-ID: <20101115100606.GC24194@n2100.arm.linux.org.uk>
References: <4CDED96A.9080404@gmail.com> <20101115092404.GA24194@n2100.arm.linux.org.uk> <201011151044.36213.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011151044.36213.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 10:44:36AM +0100, Arnd Bergmann wrote:
> On Monday 15 November 2010 10:24:04 Russell King - ARM Linux wrote:
> > This lock is in the percpu data area.  This means that when other CPUs
> > are brought online, and therefore other percpu areas are instantiated,
> > this lock will be mis-initialized (the pointers et.al. will be pointing
> > at the original percpu instance.)
> > 
> > So NAK, this will break.
> 
> I believe right now we only use the argument of __SPIN_LOCK_UNLOCKED
> as an identifier string for lockdep, but not for any pointers, so the
> patch would actually do what was intended, but break if we ever start
> relying on the pointer.
> 
> Maybe we can mangle the argument in some way to make sure it will break
> at build time when that happens, e.g.
> 
>      .lock   = __SPIN_LOCK_UNLOCKED(ipi_data.__lock)
> 
> This would at least let us remove SPIN_LOCK_UNLOCKED.

Or do one of the things I've suggested - one of which I've just completed
the code changes for, and results in this lock going away completely.
It's not a nice idea to have percpu data written to by 'foreign' CPUs.
