Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab2BORfC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:35:02 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47157 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2BORfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:35:00 -0500
Date: Wed, 15 Feb 2012 17:34:43 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Nathaniel Husted <nhusted@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: ptrace: Include linux/audit.h to fix build errors
Message-ID: <20120215173443.GF27825@n2100.arm.linux.org.uk>
References: <1329284188.12708.1.camel@phoenix> <20120215083609.GD13673@n2100.arm.linux.org.uk> <1329325622.2337.13.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329325622.2337.13.camel@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 12:07:02PM -0500, Eric Paris wrote:
> So if someone tells me how the code knows it's endianness I'll gladly
> write the ifdef to switch from AUDIT_ARCH_ARMEB to AUDIT_ARCH_ARM when
> appropriate....

An easy way would be:

#ifndef __ARMEB__
#define AUDIT_ARCH_NR AUDIT_ARCH_ARMEB
#else
#define AUDIT_ARCH_NR AUDIT_ARCH_ARM
#endif

and then:
	audit_syscall_entry(AUDIT_ARCH_NR, scno, regs->ARM_r0,
