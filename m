Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab1FUUmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:42:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:37612 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab1FUUmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:42:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,402,1304319600"; 
   d="scan'208";a="17939104"
From: Andi Kleen <andi@firstfloor.org>
To: Dan Ehrenberg <dehrenberg@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] dio: Fast-path for page-aligned IOs
References: <1308611855-18096-1-git-send-email-dehrenberg@google.com>
Date: Tue, 21 Jun 2011 13:41:07 -0700
In-Reply-To: <1308611855-18096-1-git-send-email-dehrenberg@google.com> (Dan
	Ehrenberg's message of "Mon, 20 Jun 2011 16:17:35 -0700")
Message-ID: <m2oc1q3okc.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Ehrenberg <dehrenberg@google.com> writes:

> This code introduces a fast-path variant of __blockdev_direct_IO
> for the special case where the request size is a multiple of the page
> size, the inode block size is a page, the user memory is page-aligned,
> the underlying storage is contiguous on disk and the file location is
> already initialized. The special case decreases the amount of
> bookkeeping required, which saves a significant amount of CPU time on
> a fast device such as a ramdisk or an SSD.  The patch is inspired by
> earlier code by Ken Chen.

Is it understood why your fast path is that much faster? 
i.e. what's the slow part in the normal path that it avoids?

I am wondering if some of the improvements could be gotten even for less
rigid pre conditions.

> +		/*
> +		 * The i_alloc_sem will be released at I/O completion,
> +		 * possibly in a different thread.
> +		 */
> +		down_read_non_owner(&inode->i_alloc_sem);

There's just a patch kit posted from hch which removes that semaphore.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
