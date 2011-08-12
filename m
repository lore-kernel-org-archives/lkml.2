Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1HLSdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 14:33:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:51603 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab1HLSde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 14:33:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,363,1309762800"; 
   d="scan'208";a="38883578"
From: Andi Kleen <andi@firstfloor.org>
To: melwyn lobo <linux.melwyn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: x86 memcpy performance
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com>
Date: Fri, 12 Aug 2011 11:33:33 -0700
In-Reply-To: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com>
	(melwyn lobo's message of "Fri, 12 Aug 2011 23:29:36 +0530")
Message-ID: <m2zkjelbsy.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

melwyn lobo <linux.melwyn@gmail.com> writes:

> Hi All,
> Our Video recorder application uses memcpy for every frame. About 2KB
> data every frame on Intel® Atom™ Z5xx processor.
> With default 2.6.35 kernel we got 19.6 fps. But it seems kernel
> implemented memcpy is suboptimal, because when we replaced
> with an optmized one (using ssse3, exact patches are currently being
> finalized) ew obtained 22fps a gain of 12.2 %.

SSE3 in the kernel memcpy would be incredible expensive,
it would need a full FPU saving for every call and preemption
disabled.

I haven't seen your patches, but until you get all that 
right (and add a lot more overhead to most copies) you
have a good change currently to corrupting user FPU state.

> C0 residency also reduced from 75% to 67%. This means power benefits too.
> My questions:
> 1. Is kernel memcpy profiled for optimal performance.

It depends on the CPU

There have been some improvements for Atom on newer kernels
I believe. 

But then kernel memcpy is usually optimized for relatively
small copies (<= 4K) because very few kernel loads do more.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
