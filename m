Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab2BOJwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:52:46 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38899 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647Ab2BOJwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:52:42 -0500
Date: Wed, 15 Feb 2012 09:52:16 +0000
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nathaniel Husted <nhusted@gmail.com>, Eric Paris <eparis@redhat.com>,
        Dave Martin <dave.martin@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: ptrace: Include linux/audit.h to fix build errors
Message-ID: <20120215095216.GA29319@mudshark.cambridge.arm.com>
References: <1329284188.12708.1.camel@phoenix>
 <20120215083609.GD13673@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215083609.GD13673@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 08:36:09AM +0000, Russell King - ARM Linux wrote:
> On Wed, Feb 15, 2012 at 01:36:28PM +0800, Axel Lin wrote:
> > Include linux/audit.h to fix below build errors:
> > 
> >   CC      arch/arm/kernel/ptrace.o
> > arch/arm/kernel/ptrace.c: In function 'syscall_trace':
> > arch/arm/kernel/ptrace.c:919: error: implicit declaration of function 'audit_syscall_exit'
> > arch/arm/kernel/ptrace.c:921: error: implicit declaration of function 'audit_syscall_entry'
> > arch/arm/kernel/ptrace.c:921: error: 'AUDIT_ARCH_ARMEB' undeclared (first use in this function)
> 
> Err, can someone explain why we seem to tell the audit code that we're
> always big endian?

I can't see this patch in the linux-arm-kernel archives, so that's probably
why we missed it. The fix should be pretty straightforward though - Axel,
care to add the appropriate ifdeffery?

Will
