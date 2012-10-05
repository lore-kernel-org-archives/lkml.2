Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab2JEQzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:55:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:37334 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771Ab2JEQzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:55:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,541,1344236400"; 
   d="scan'208";a="152878026"
From: Andi Kleen <andi@firstfloor.org>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        x86@kernel.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 0/7] Improve swiotlb performance by using physical addresses
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com>
Date: Fri, 05 Oct 2012 09:55:39 -0700
In-Reply-To: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com> (Alexander
	Duyck's message of "Wed, 03 Oct 2012 17:38:41 -0700")
Message-ID: <m28vbkx3hw.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Duyck <alexander.h.duyck@intel.com> writes:

> While working on 10Gb/s routing performance I found a significant amount of
> time was being spent in the swiotlb DMA handler.  Further digging found that a
> significant amount of this was due to the fact that virtual to physical
> address translation and calling the function that did it.  It accounted for
> nearly 60% of the total overhead.

Can you find out why that is? Traditionally virt_to_phys was just a
subtraction. Then later on it was a if and a subtraction.

It cannot really be that expensive. Do you have some debugging enabled?

Really virt_to_phys should be fixed. Such fundamental operations
shouldn't slow. I don't think hacking up all the users to work
around this is the r ight way.

Looking at the code a bit someone (crazy) made it out of line.
But that cannot explain that much overhead.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
