Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab0L3KaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 05:30:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47642 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab0L3KaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 05:30:16 -0500
Date: Thu, 30 Dec 2010 11:30:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [boot crash] Re: [PATCH -v2 3/6] x86, 64bit, numa: Put pgtable
 to local node memory
Message-ID: <20101230103002.GA30020@elte.hu>
References: <4D1933D1.9020609@kernel.org>
 <4D1BC856.4010202@kernel.org>
 <4D1BC94C.5040100@zytor.com>
 <AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com>
 <alpine.DEB.2.00.1012291637270.6040@chino.kir.corp.google.com>
 <4D1BD928.50701@zytor.com>
 <alpine.DEB.2.00.1012291702180.7374@chino.kir.corp.google.com>
 <4D1BE615.4000700@zytor.com>
 <20101230090648.GB7306@elte.hu>
 <20101230102815.GA29822@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101230102815.GA29822@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> FYI, either the x86/numa or the x86/bootmem changes cause the early boot crash 
> below. Config attached.

It's x86/bootmem, one of these commits:

3c417751e4f0: x86: Rename e820_table_* to pgt_buf_*
d7992231c148: x86-64: Move out cleanup higmap [_brk_end, _end) out of init_memory_mapping()
4645b6af9427: x86: Use early pre-allocated page table buffer top-down
1411e0ec3123: x86-64, numa: Put pgtable to local node memory
dbef7b56d2fc: x86-64, numa: Allocate memnodemap under max_pfn_mapped
45635ab5e41b: x86: Change get_max_mapped() to inline
1a4a678b12c8: memblock: Make find_memory_core_early() find from top-down
32e3f2b00c52: x86-64, gart: Fix allocation with memblock
4b239f458c22: x86-64, mm: Put early page table high

i'm excluding them from tip:master for now.

Thanks,

	Ingo
