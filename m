Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1FCR05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 13:26:57 -0400
Received: from science.horizon.com ([71.41.210.146]:29060 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753546Ab1FCR04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 13:26:56 -0400
Date: 3 Jun 2011 13:26:52 -0400
Message-ID: <20110603172652.11807.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org
Subject: How to measure enable_kernel_fpu overhead?
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on some crypto primitives, and have MMX and SSE2 accelerated
versions.  I plan on writing AltiVec (PPC) and NEON (ARM) ones, too.

But the performance varies, so I think I need to do some run-time
benchmarking, like the RAID6 code.

But what's even more annoying is that unlike the RAID6 code, I can't
assume I'll alawys be working on large blocks.  So it's not so much about
choosing one version as choosing a size threshold at which to switch over.

Which leads us into the overhead of enable_kernel_fpu(),
enable_kernel_altivec(), and whatever the ARM equivalent is.
(Um, did a little searching... does it even exist?)

To complicate it a little more, there are at two timing cases, depending
on the value of current_thread_info()->status & TS_USEDFPU.  (For PowerPC,
it's current->thread.regs->msr & MSR_VEC.)

There may be additional timing variation depending on how clever XSAVE
is with e.g. the high half of the ymm registers.


So I think the thing to do is benchmark a few different sizes in the two
timing cases and fit a linear function to the results.  (More simply,
subtract the timings from the integer code and find the X-intercept of
that function.)

But I'm not sure how to create, a suitably dirty user FPU state.
Especially as it might be early boot and there might not be any user
processes yet to save it to.

Does anyone have any suggestions?

Thank you!
