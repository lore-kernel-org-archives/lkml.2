Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab2EORqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:46:44 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51146 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755640Ab2EORql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:46:41 -0400
X-Sasl-enc: 4F6ttcSX/oZBRt5gsJeiXlZ9enHCejAHG5wBMdJqknKr 1337104000
Date: Tue, 15 May 2012 10:46:39 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NVM Mapping API
Message-ID: <20120515174639.GA31752@kroah.com>
References: <20120515133450.GD22985@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515133450.GD22985@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 09:34:51AM -0400, Matthew Wilcox wrote:
> 
> There are a number of interesting non-volatile memory (NVM) technologies
> being developed.  Some of them promise DRAM-comparable latencies and
> bandwidths.  At Intel, we've been thinking about various ways to present
> those to software.  This is a first draft of an API that supports the
> operations we see as necessary.  Patches can follow easily enough once
> we've settled on an API.
> 
> We think the appropriate way to present directly addressable NVM to
> in-kernel users is through a filesystem.  Different technologies may want
> to use different filesystems, or maybe some forms of directly addressable
> NVM will want to use the same filesystem as each other.
> 
> For mapping regions of NVM into the kernel address space, we think we need
> map, unmap, protect and sync operations; see kerneldoc for them below.
> We also think we need read and write operations (to copy to/from DRAM).
> The kernel_read() function already exists, and I don't think it would
> be unreasonable to add its kernel_write() counterpart.
> 
> We aren't yet proposing a mechanism for carving up the NVM into regions.
> vfs_truncate() seems like a reasonable API for resizing an NVM region.
> filp_open() also seems reasonable for turning a name into a file pointer.
> 
> What we'd really like is for people to think about how they might use
> fast NVM inside the kernel.  There's likely to be a lot of it (at least in
> servers); all the technologies are promising cheaper per-bit prices than
> DRAM, so it's likely to be sold in larger capacities than DRAM is today.
> 
> Caching is one obvious use (be it FS-Cache, Bcache, Flashcache or
> something else), but I bet there are more radical things we can do
> with it.  What if we stored the inode cache in it?  Would booting with
> a hot inode cache improve boot times?  How about storing the tree of
> 'struct devices' in it so we don't have to rescan the busses at startup?

Rescanning the busses at startup are required anyway, as devices can be
added and removed when the power is off, and I would be amazed if that
is actually taking any measurable time.  Do you have any numbers for
this for different busses?

What about pramfs for the nvram?  I have a recent copy of the patches,
and I think they are clean enough for acceptance, there was no
complaints the last time it was suggested.  Can you use that for this
type of hardware?

thanks,

greg k-h
