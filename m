Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967Ab2BOKTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 05:19:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37568 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758929Ab2BOKTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 05:19:11 -0500
Date: Wed, 15 Feb 2012 10:18:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nathaniel Husted <nhusted@gmail.com>, Eric Paris <eparis@redhat.com>,
        Dave Martin <dave.martin@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: ptrace: Include linux/audit.h to fix build errors
Message-ID: <20120215101832.GF13673@n2100.arm.linux.org.uk>
References: <1329284188.12708.1.camel@phoenix> <20120215083609.GD13673@n2100.arm.linux.org.uk> <20120215095216.GA29319@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215095216.GA29319@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 09:52:16AM +0000, Will Deacon wrote:
> On Wed, Feb 15, 2012 at 08:36:09AM +0000, Russell King - ARM Linux wrote:
> > On Wed, Feb 15, 2012 at 01:36:28PM +0800, Axel Lin wrote:
> > > Include linux/audit.h to fix below build errors:
> > > 
> > >   CC      arch/arm/kernel/ptrace.o
> > > arch/arm/kernel/ptrace.c: In function 'syscall_trace':
> > > arch/arm/kernel/ptrace.c:919: error: implicit declaration of function 'audit_syscall_exit'
> > > arch/arm/kernel/ptrace.c:921: error: implicit declaration of function 'audit_syscall_entry'
> > > arch/arm/kernel/ptrace.c:921: error: 'AUDIT_ARCH_ARMEB' undeclared (first use in this function)
> > 
> > Err, can someone explain why we seem to tell the audit code that we're
> > always big endian?
> 
> I can't see this patch in the linux-arm-kernel archives, so that's probably
> why we missed it. The fix should be pretty straightforward though - Axel,
> care to add the appropriate ifdeffery?

In which case the BIG QUESTION is how the hell this ever got into mainline
without being seen by any ARM people.  I've checked my mailboxes and, like
you, can find no trace of this patch.  The only trace of it I can find is:

http://www.redhat.com/archives/linux-audit/2011-August/msg00000.html

and a repost as part of a patch set in November.

This is a patch which should have been reviewed by ARM folk to catch bugs
like the above.

So, this gives us two options: either we revert the damned thing and start
over with it (and hopefully audit folk will start co-operating with ARM
folk) or we try to fix up their mess (and potentially they learn they can
dump crap on us.)
