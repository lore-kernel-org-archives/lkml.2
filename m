Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab1FEAX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 20:23:29 -0400
Received: from science.horizon.com ([71.41.210.146]:22345 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751717Ab1FEAX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 20:23:26 -0400
Date: 4 Jun 2011 20:23:23 -0400
Message-ID: <20110605002323.16365.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: andi@firstfloor.org
Subject: Re: How to measure enable_kernel_fpu overhead?
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
In-Reply-To: <m2pqmts654.fsf@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This seems to clever for its own good. Even if you come up with some
> number on one CPU it could be completely different on another.
> I would suggest KISS.

I don't understand.  Do you mean different CPUs of the same SMP system?
That would be really bad...

The whole point is to, like the RAID6 code, benchmark after boot time
so that the numbers reflect the individual hardware instance.

Doing that in a clean maintainable way suitabkle for merging into Linus's
tree is the problem.  If I just needed a one-off rude hack to measure
on my systems, it would be easy.  But that's so obviously not useful
that I didn't bother to mention it.

"Too clever for its own good" would be to keep more statistics, including
confidence intervals, on actual calls, and randomly dispatch requests
to code paths based on the current estimated probabilities of A being
faster than B.

That avoids doing redundant work just for benchmarking, but does entail
quite a lot of bookkeeping overhead.  I'd rather just measure once at boot
(or module load) and be done with it.


Anyway, thanks for thinking about the problem.
