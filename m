Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0JNGhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 02:37:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49366 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933Ab0JNGhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 02:37:21 -0400
Date: Thu, 14 Oct 2010 08:37:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/memblock] x86-64: Only set max_pfn_mapped to 512 MiB
 if we enter via head_64.S
Message-ID: <20101014063706.GA23561@elte.hu>
References: <4CB641F7.9040103@goop.org>
 <tip-859ee4f57fb4e91de8439496f62eb996f4a28ca8@git.kernel.org>
 <20101014055714.GA3329@elte.hu>
 <4CB69E22.2010005@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB69E22.2010005@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On 10/13/2010 10:57 PM, Ingo Molnar wrote:
> > 
> > * tip-bot for Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > 
> >> Commit-ID:  859ee4f57fb4e91de8439496f62eb996f4a28ca8
> >> Gitweb:     http://git.kernel.org/tip/859ee4f57fb4e91de8439496f62eb996f4a28ca8
> >> Author:     Jeremy Fitzhardinge <jeremy@goop.org>
> >> AuthorDate: Wed, 13 Oct 2010 16:34:15 -0700
> >> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> >> CommitDate: Wed, 13 Oct 2010 17:09:59 -0700
> >>
> >> x86-64: Only set max_pfn_mapped to 512 MiB if we enter via head_64.S
> >>
> >> head_64.S maps up to 512 MiB, but that is not necessarity true for
> >> other entry paths, such as Xen.
> > 
> > These two commits are a boot crasher on x86 defconfig (64-bit):
> > 
> > [    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
> > [    0.000000]  0000000000 - 003fe00000 page 2M
> > [    0.000000]  003fe00000 - 003fff0000 page 4k
> > [    0.000000] Kernel panic - not syncing: Cannot find space for the kernel page tables
> > [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.36-rc7-tip+ #49192
> > [    0.000000] Call Trace:
> > [    0.000000]  [<ffffffff8156c73f>] panic+0x8c/0x192
> > [    0.000000]  [<ffffffff8156c881>] ? printk+0x3c/0x3e
> > [    0.000000]  [<ffffffff8154ec40>] init_memory_mapping+0x372/0x506
> > [    0.000000]  [<ffffffff819053ed>] ? memblock_x86_reserve_range+0x7c/0x83
> > [    0.000000]  [<ffffffff818f2f3d>] setup_arch+0x5a3/0xa68
> > [    0.000000]  [<ffffffff8156c881>] ? printk+0x3c/0x3e
> > [    0.000000]  [<ffffffff81061135>] ? clockevents_register_notifier+0x3e/0x4a
> > [    0.000000]  [<ffffffff818ef9e1>] start_kernel+0x83/0x36e
> > [    0.000000]  [<ffffffff818ef2a8>] x86_64_start_reservations+0xb8/0xbc
> > [    0.000000]  [<ffffffff818ef393>] x86_64_start_kernel+0xe7/0xee
> 
> max_pfn_mapped is in .bss section. so it get cleared.
> 
> will have a patch to move clear_bss from head64.c to head_64.S

Ok, great - thanks!

	Ingo
