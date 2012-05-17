Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967652Ab2EQTFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 15:05:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:17036 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967636Ab2EQTFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 15:05:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101327678"
Date: Thu, 17 May 2012 15:06:18 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: NVM Mapping API
Message-ID: <20120517190618.GQ22985@linux.intel.com>
References: <20120515133450.GD22985@linux.intel.com>
 <1337149453.1961.24.camel@slavad-ubuntu-11>
 <20120516215849.GC32221@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516215849.GC32221@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 05:58:49PM -0400, Benjamin LaHaise wrote:
> The big question I have is what the actual interface for these types of 
> memory will be.  If they're like actual RAM and can be mmap()ed into user 
> space, it will be preferable to avoid as much of the overhead of the existing 
> block infrastructure that most current day filesystems are built on top of.  

Yes.  I'm hoping that filesystem developers will indicate enthusiasm
for moving to new APIs.  If not the ones I've proposed, then at least
ones which can be implemented more efficiently with a device that looks
like DRAM.

> If the devices have only modest endurance limits, we may need to stick the 
> kernel in the middle to prevent malicious code from wearing out a user's 
> memory cells.

Yes, or if the device has long write latencies or poor write bandwidth,
we'll also want to buffer writes in DRAM.  My theory is that this is
doable transparently to the user; we can map it read-only, and handle
the fault by copying from NVM to DRAM, then changing the mapping and
restarting the instruction.  The page would be written back to NVM on
a sync call, or when memory pressure or elapsed time dictates.
