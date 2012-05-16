Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab2EPP4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:56:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:4891 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922Ab2EPP4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:56:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="143959708"
Date: Wed, 16 May 2012 11:57:28 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Greg KH <greg@kroah.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NVM Mapping API
Message-ID: <20120516155728.GH22985@linux.intel.com>
References: <20120515133450.GD22985@linux.intel.com>
 <20120515174639.GA31752@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515174639.GA31752@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 10:46:39AM -0700, Greg KH wrote:
> On Tue, May 15, 2012 at 09:34:51AM -0400, Matthew Wilcox wrote:
> > What we'd really like is for people to think about how they might use
> > fast NVM inside the kernel.  There's likely to be a lot of it (at least in
> > servers); all the technologies are promising cheaper per-bit prices than
> > DRAM, so it's likely to be sold in larger capacities than DRAM is today.
> > 
> > Caching is one obvious use (be it FS-Cache, Bcache, Flashcache or
> > something else), but I bet there are more radical things we can do
> > with it.  What if we stored the inode cache in it?  Would booting with
> > a hot inode cache improve boot times?  How about storing the tree of
> > 'struct devices' in it so we don't have to rescan the busses at startup?
> 
> Rescanning the busses at startup are required anyway, as devices can be
> added and removed when the power is off, and I would be amazed if that
> is actually taking any measurable time.  Do you have any numbers for
> this for different busses?

Hi Greg,

I wasn't particularly serious about this example ... I did once time
the scan of a PCIe bus and it took a noticable number of milliseconds
(which is why we now only scan the first device for the downstream "bus"
of root ports and downstream ports).

I'm just trying to stimulate a bit of discussion of possible usages for
persistent memory.

> What about pramfs for the nvram?  I have a recent copy of the patches,
> and I think they are clean enough for acceptance, there was no
> complaints the last time it was suggested.  Can you use that for this
> type of hardware?

pramfs is definitely one filesystem that's under investigation.  I know
there will be types of NVM for which it won't be suitable, so rather
than people calling pramfs-specific functions, the notion is to get a
core API in the VFS that can call into the various different filesystems
that can handle the vagaries of different types of NVM.

Thanks.
