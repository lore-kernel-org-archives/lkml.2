Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab0FGJi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 05:38:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:49837 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0FGJi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 05:38:27 -0400
Subject: Re: [Q] Perf-events callchain support on MIPS
From: Peter Zijlstra <peterz@infradead.org>
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikb5jAw_fSQ08IMrzwKK7lfafXlm63S46F-C8m0@mail.gmail.com>
References: <AANLkTikb5jAw_fSQ08IMrzwKK7lfafXlm63S46F-C8m0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 11:38:25 +0200
Message-ID: <1275903505.1645.549.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-06 at 07:41 +0800, Deng-Cheng Zhu wrote:
> Hi, Peter and Ingo
> 
> 
> For MIPS, recording user stack backtrace in the kernel is not quite as easy
> as on other platforms. Because In the kernel, we don't have frame unwinder
> to work on the user stack. Given the different possible compiler flags,
> getting the backtrace for the user stack is especially challenging.
> 
> So, is it still useful to implement the Perf-events callchain support on
> MIPS with only kernel addresses recorded for now? What impact do you see to
> do so? Only that the user can not see user-level performance bottleneck?

Note that on x86 we rely on framepointers (a compiler option) for both
kernel and user unwinds. If you compile either without, you will not
obtain callchains for that particular section.

So yeah, we already have something similar to that on x86 since most
distros don't actually build their userspace with framepointers enabled
(although on x86_64 they really should).

Just provide as much information as you can, if/when you find a way to
provide userspace callchains you can always add that later.

