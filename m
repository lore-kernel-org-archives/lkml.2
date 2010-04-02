Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0DBOr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 10:47:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563Ab0DBOrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 10:47:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.1004011310210.3707@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004011310210.3707@i5.linux-foundation.org> <20100325194100.GA2364@debian> <20100331134048.da4e35a7.akpm@linux-foundation.org> <4BB3B4DB.7040904@kernel.org> <20100331135220.c6695a51.akpm@linux-foundation.org> <4BB3BAD6.50308@zytor.com> <alpine.LFD.2.00.1004010904540.3707@i5.linux-foundation.org> <20100401102744.a4e6f24d.akpm@linux-foundation.org> 
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Rabin Vincent <rabin@rab.in>, lkml <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, cl@linux-foundation.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org
Subject: Re: start_kernel(): bug: interrupts were enabled early
Date: Fri, 02 Apr 2010 15:46:14 +0100
Message-ID: <28599.1270219574@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Ahh, yes. In this case, that doesn't likely change anything. The 
> save/restore versions of the irq-safe locks shouldn't be appreciably more 
> expensive than the non-saving ones. And architectures that really care 
> should have done their own per-arch optimized version anyway.

That depends on the CPU.  Some CPUs have quite expensive interrupt disablement
instructions.  FRV does for instance; but fortunately, on the FRV, I can use
some of the excessive quantities of conditional registers to pretend that I
disable interrupts, and only actually do so if an interrupt actually happens.

> Maybe we should even document that - so that nobody else makes the mistake 
> x86-64 did of thinking that the "generic spinlock" version of the rwsem's 
> is anything but a hacky and bad fallback case.

In some cases, it's actually the best way.  On a UP machine, for instance,
where they reduce to nothing or where your only atomic instruction is an XCHG
equivalent.

David
