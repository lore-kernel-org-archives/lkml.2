Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab0KMNPu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 08:15:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57403 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab0KMNPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 08:15:48 -0500
Date: Sat, 13 Nov 2010 13:15:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Atul Sowani <sowani@gmail.com>
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        linux-arm-kernel@lists.infradead.org, alan@linux.intel.com
Subject: Re: [PATCH 2.6.36 1/1] kernel SPIN_LOCK_UNLOCKED changed to
	__SPIN_LOCK_UNLOCKED()
Message-ID: <20101113131537.GB26105@n2100.arm.linux.org.uk>
References: <4CD823DC.8030201@gmail.com> <4CDE7D65.6060203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDE7D65.6060203@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 05:28:29PM +0530, Atul Sowani wrote:
> Atul Sowani wrote:
> > There are still some files containing .lock = SPIN_LOCK_UNLOCKED type
> > assignments which should be converted to __SPIN_LOCK_UNLOCKED().
> > 
> > Signed-off-by: Atul Sowani <sowani@gmail.com>
> > ---
> > 
> > diff -uprN a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> > --- a/arch/arm/kernel/smp.c	2010-10-21 02:00:22.000000000 +0530
> > +++ b/arch/arm/kernel/smp.c	2010-11-07 00:47:32.000000000 +0530
> > @@ -56,7 +56,7 @@ struct ipi_data {
> >  };
> > 
> >  static DEFINE_PER_CPU(struct ipi_data, ipi_data) = {
> > -	.lock	= SPIN_LOCK_UNLOCKED,
> > +	.lock	= __SPIN_LOCK_UNLOCKED (ipi_data.lock),

No space between UNLOCKED and (.

> I made original patch submission on 08.Nov.2010. I am wondering if
> this patch will be useful and is correct. Please comment.

This is the first I've seen of this patch.  For the ARM part, with the
above fixed:

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
