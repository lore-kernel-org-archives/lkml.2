Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1JKNxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:53:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62372 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1JKNxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:53:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paul.mckenney@linaro.org>
Subject: Re: [PATCHv16 0/9] Contiguous Memory Allocator
Date: Tue, 11 Oct 2011 15:52:04 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com> <201110071827.06366.arnd@arndb.de> <20111010155642.38df59af.akpm@linux-foundation.org>
In-Reply-To: <20111010155642.38df59af.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110111552.04615.arnd@arndb.de>
X-Provags-ID: V02:K0:yC32WDqXlHZmLdMvPM7F9vV584e/uF+AscSbowpelb4
 XBB6/8AY92PB5hEYjA1NECNZXIfFsN2dVHrK8amukQ2qqSd5Il
 y7vEwrr//CgrxAhsUPg4iD6k7vk5lTSfP5BNFfxfB+Un9Bn18V
 Jf/C1NW+kcHH1s2KnsAvdMq/iKX60YDNCFYyxj84ILxCu2jWsl
 kNBaVxX/UmlFy5wT6vl0A3GEYCFN5KkkBaCVm4d+kLlzNaqWxV
 CBghHq6c2CJMOv0TzpLOT8974+tlPtFn6fWn+GAmv+Ke8OZewb
 r7bjSlCwWnk09oFqfnIruCQSdcNtgKVm3wufDsqdgcO3937tLt
 n2dD4VOU0iqDj9Z47AGM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 October 2011, Andrew Morton wrote:
> Russell's going to hate me, but...
> 
> I do know that he had substantial objections to at least earlier
> versions of this, and he is a guy who knows of what he speaks.
> 
> So I would want to get a nod from rmk on this work before proceeding. 
> If that nod isn't available then let's please identify the issues and
> see what we can do about them.

I'm pretty sure that Russell's concerns were almost entirely about the
ARM specific parts, which were extremely hard to figure out. The
most important technical concern back in July was that the patch
series at the time did not address the problem of conflicting pte
flags when we remap memory as uncached on ARMv6. He had a patch
to address this problem that was supposed to get merged in 3.1
and would have conflicted with the CMA patch set.

Things have changed a lot since then. Russell had to revert his
own patch because he found regressions using it on older machines.
However, the current CMA on ARM patch AFAICT reliably fixes this
problem now and does not cause the same regression on older machines.
The solution used now is the one we agreed on after sitting together
for a few hours with Russell, Marek, Paul McKenney and myself.

If there are still concerns over the ARM specific portion of
the patch series, I'm very confident that we can resolve these
now (I was much less so before that meeting).

What I would really want to hear from you is your opinion on
the architecture independent stuff. Obviously, ARM is the
most important consumer of the patch set, but I think the
code has its merit on other architectures as well and most of
them (maybe not parisc) should be about as simple as the x86
one that Marek posted now with v16.

	Arnd
