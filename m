Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422Ab2HHNzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:55:17 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39107 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2HHNzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:55:15 -0400
Date: Wed, 8 Aug 2012 09:55:12 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 01/22] ARM: add mechanism for late code patching
In-Reply-To: <5022673A.7060407@ti.com>
Message-ID: <alpine.LFD.2.02.1208080948210.5231@xanadu.home>
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-2-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1208040045360.5231@xanadu.home> <50219C45.7030601@ti.com> <alpine.LFD.2.02.1208080106500.5231@xanadu.home>
 <5022673A.7060407@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2012, Cyril Chemparathy wrote:

> On 08/08/12 01:56, Nicolas Pitre wrote:
> > On Tue, 7 Aug 2012, Cyril Chemparathy wrote:
> [...]
> > > u32 arm_check[] = {
> > > 	0xe2810041, 0xe2810082, 0xe2810f41, 0xe2810f82, 0xe2810e41,
> > > 	0xe2810e82, 0xe2810d41, 0xe2810d82, 0xe2810c41, 0xe2810c82,
> > > 	0xe2810b41, 0xe2810b82, 0xe2810a41, 0xe2810a82, 0xe2810941,
> > > 	0xe2810982, 0xe2810841, 0xe2810882, 0xe2810741, 0xe2810782,
> > > 	0xe2810641, 0xe2810682, 0xe2810541, 0xe2810582, 0xe2810441,
> > > };
> > 
> > Instead of using this array you could let the assembler do it for you
> > like this:
> > 
> > asm (" \n\
> > 	.arm \n\
> > arm_check: \n\
> >          .set shft, 0 \n\
> >          .rep 12 \n\
> >          add     r1, r2, #0x81 << \shft \n\
> >          .set shft, \shft + 2 \n\
> >          .endr \n\
> > ");
> > 
> 
> Neat macro magic.  Are you thinking that we build this in as a self test in
> the code?

For such things, this is never a bad idea to have some test alongside 
with the main code, especially if this is extended to more cases in the 
future.  It is too easy to break it in subtle ways.

See arch/arm/kernel/kprobes-test*.c for a precedent.


Nicolas
