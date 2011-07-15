Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1GOPvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:51:12 -0400
Received: from iabervon.org ([66.92.72.58]:32926 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab1GOPvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:51:11 -0400
Date: Fri, 15 Jul 2011 11:43:47 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Seth Forshee <seth.forshee@canonical.com>
cc: Christoph Hellwig <hch@tuxera.com>, linux-kernel@vger.kernel.org
Subject: Re: Problems with hfsplus on ipods in 2.6.38+
In-Reply-To: <20110715143900.GB19063@thinkpad-t410>
Message-ID: <alpine.LNX.2.00.1107151035030.2056@iabervon.org>
References: <alpine.LNX.2.00.1107131942190.2056@iabervon.org> <20110714135302.GA28501@thinkpad-t410> <alpine.LNX.2.00.1107141330370.2056@iabervon.org> <alpine.LNX.2.00.1107142116260.2056@iabervon.org> <20110715143900.GB19063@thinkpad-t410>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jul 2011, Seth Forshee wrote:

> On Thu, Jul 14, 2011 at 09:26:11PM -0400, Daniel Barkalow wrote:
> > Okay, I've applied that patch set, and it worked for me without any issues 
> > thus far. If you're interested in the debugging output from a device that 
> > doesn't work with vanilla but doesn't oops or panic with that patch set, 
> > it's attached. I'm using 32-bit x86, if that helps for tracking down 
> > differences.
> 
> Hrm, looks like I used %lu for sector_t instead of %llu, and that's
> messing up the output on 32-bit builds. What I am able to see looks
> correct though. I put up a new version of the patches with the output
> fixed along with a new build on the bug.
> 
> I've had some success producing problems using scsi_debug with a 64-bit
> build, specifically with 1K or 2K sectors. Actually a lot of odd things
> happen with those sector sizes, and they happen whether using my patch
> or reverting the two patches that change hfsplus to using bio, so those
> problems seem unrelated. What I see is that the free/used space numbers
> reported by df don't make sense given the actual files I've copied to
> the volume. If I "fill" the volume (in quotes because really I haven't
> copied in enough data to fill the volume, but it says it's full anyway)
> df reports complete garbage. Then if I proceed to remove all files from
> the volume df still reports that 50% of the space is used. These
> problems aren't present with 512 byte or 4K sectors.
> 
> What I also see are GPFs in memory allocation code, which is what I
> believe others have seen with my patch, and so far I haven't seen those
> with the reversions. So I'm suspecting memory corruption, but I don't
> yet see where the corruption is coming form. I found one problem, but I
> don't suspect it's responsible for the GPFs.

A while later, somewhat after I'd unmounted the filesystem (and sent the 
email), I got some memory allocation oopses, also, followed eventually by 
some sort of hang (userspace not working but alt-sysrq did work). So I 
agree with the memory corruption idea. Do you want corrected debugging 
output, or any other information from my actual device, or are you set 
with scsi_debug for now?

	-Daniel
*This .sig left intentionally blank*
