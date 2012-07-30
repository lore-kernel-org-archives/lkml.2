Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab2G3OQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:16:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51789 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2G3OQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:16:04 -0400
Date: Mon, 30 Jul 2012 15:15:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 11/11] ARM: Get rid of .LCcralign local label usage in
	alignment_trap macro
Message-ID: <20120730141544.GJ6802@n2100.arm.linux.org.uk>
References: <20120730115719.GA5742@lizard> <1343649500-18491-11-git-send-email-anton.vorontsov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343649500-18491-11-git-send-email-anton.vorontsov@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 04:58:20AM -0700, Anton Vorontsov wrote:
> This makes the code more izolated.
> 
> The downside of this is that we now have an additional branch and the
> code itself is 8 bytes longer. But on the bright side, this new layout
> can be more cache friendly since cr_alignment address might be already
> in the cache line (not that I measured anything, it's just fun to think
> about it).

The caches are harvard, so mixing data and code together does not increase
performance.  Having data which is used by the same code in the same cache
line results in better performance.

The additional branch will also cause a pipeline stall on older CPUs.

So no, I don't see any way that this is a performance improvement.  Please
leave this as is.
