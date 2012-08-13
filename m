Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2HMV6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 17:58:35 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:40503 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab2HMV6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 17:58:33 -0400
Date: Mon, 13 Aug 2012 14:58:29 -0700
From: Tejun Heo <tj@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/5] x86: Only direct map addresses that are marked as
 E820_RAM
Message-ID: <20120813215829.GA25632@google.com>
References: <1344894424-4434-1-git-send-email-jacob.shin@amd.com>
 <1344894424-4434-2-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344894424-4434-2-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 13, 2012 at 04:47:00PM -0500, Jacob Shin wrote:
> Currently direct mappings are created for [ 0 to max_low_pfn<<PAGE_SHIFT )
> and [ 4GB to max_pfn<<PAGE_SHIFT ), which may include regions that are not
> backed by actual DRAM. This is fine for holes under 4GB which are covered
> by fixed and variable range MTRRs to be UC. However, we run into trouble
> on higher memory addresses which cannot be covered by MTRRs.

I presume one of the problems is the mysterious reboot on S4 resume?
Please be a bit more detailed.  Let's say someone discovers a
performance regression on an obscure machine, say, two years from now,
which isn't too crazy given how enterprises roll.  Somebody bisects it
to this commit.  Then what?  It's very difficult to assess whether the
said "problem" is something which we should avoid at the cost of the
regression or it was just something somebody thought might be a
problem and created the patch assuming the change wouldn't affect
anything.

So, *please* explain what the problems are, preferably with
LKML-References or links to bugzilla bugs if there are any.

> This patch iterates through e820 and only direct maps ranges that are
> marked as E820_RAM, and keeps track of those pfn ranges.

Also, please mention the possibility of using smaller size memory
mappings if e820 didn't align physical memory to GB boundary.

Thanks.

-- 
tejun
