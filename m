Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2EPQBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 12:01:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:9783 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab2EPQBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 12:01:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100809299"
Date: Wed, 16 May 2012 12:02:36 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NVM Mapping API
Message-ID: <20120516160236.GI22985@linux.intel.com>
References: <20120515133450.GD22985@linux.intel.com>
 <4FB2E069.7060703@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB2E069.7060703@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 04:02:01PM -0700, Andy Lutomirski wrote:
> I would love to use this from userspace.  If I could carve out a little
> piece of NVM as a file (or whatever) and mmap it, I could do all kinds
> of fun things with that.  It would be nice if it had well-defined, or at
> least configurable or discoverable, caching properties (e.g. WB, WT, WC,
> UC, etc.).

Yes, usage from userspace is definitely planned; again through a
filesystem interface.  Treating it like a regular file will work as
expected; the question is how to expose the interesting properties
(eg is there a lighter weight mechanism than calling msync()).

My hope was that by having a discussion of how to use this stuff within
the kernel, we might come up with some usage models that would inform
how we design a user space library.

> (Even better would be a way to make a clone of an fd that only allows
> mmap, but that's a mostly unrelated issue.)

O_MMAP_ONLY?  And I'm not sure why you'd want to forbid reads and writes.
