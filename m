Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2HAUzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:55:24 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:46871 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab2HAUzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:55:23 -0400
Date: Wed, 1 Aug 2012 13:53:06 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 11/11] ARM: Get rid of .LCcralign local label usage in
 alignment_trap macro
Message-ID: <20120801205306.GB20714@lizard>
References: <20120730115719.GA5742@lizard>
 <1343649500-18491-11-git-send-email-anton.vorontsov@linaro.org>
 <20120730141544.GJ6802@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120730141544.GJ6802@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 03:15:44PM +0100, Russell King - ARM Linux wrote:
> On Mon, Jul 30, 2012 at 04:58:20AM -0700, Anton Vorontsov wrote:
> > This makes the code more izolated.
> > 
> > The downside of this is that we now have an additional branch and the
> > code itself is 8 bytes longer. But on the bright side, this new layout
> > can be more cache friendly since cr_alignment address might be already
> > in the cache line (not that I measured anything, it's just fun to think
> > about it).
> 
> The caches are harvard, so mixing data and code together does not increase
> performance.  Having data which is used by the same code in the same cache
> line results in better performance.
> 
> The additional branch will also cause a pipeline stall on older CPUs.
> 
> So no, I don't see any way that this is a performance improvement.  Please
> leave this as is.

Sure, will drop it.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
