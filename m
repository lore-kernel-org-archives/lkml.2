Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab1FSWg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 18:36:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:19714 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab1FSWg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 18:36:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,390,1304319600"; 
   d="scan'208";a="16943613"
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Meelis Roos <mroos@linux.ee>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        sparclinux@vger.kernel.org
Subject: Re: reorganized struct inode results in unaligned accesses
References: <alpine.SOC.1.00.1106191927250.4844@math.ut.ee>
	<BANLkTiktb6GS7fcHRRgC=bHJjz8k0hVmPw@mail.gmail.com>
Date: Sun, 19 Jun 2011 15:35:30 -0700
In-Reply-To: <BANLkTiktb6GS7fcHRRgC=bHJjz8k0hVmPw@mail.gmail.com> (Linus
	Torvalds's message of "Sun, 19 Jun 2011 09:51:24 -0700")
Message-ID: <m2boxtfo0d.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> Dang. I guess it needs to be made "unsigned long" again. Which is a
> shame, because we only use a couple of bits from there, and "struct
> inode" really is much too big already.

In the past it was usually enough to just align it to alignof(unsigned
long), not actually make it long. struct page went through this
a long time ago.

This could cause r-m-w races with the next field in theory, but assuming
it's reasonably read-only (ie only set up at inode creation time)
that should be fine.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
