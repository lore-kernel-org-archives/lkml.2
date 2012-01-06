Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab2AFFGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 00:06:20 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:34864 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948Ab2AFFFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 00:05:51 -0500
X-Sasl-enc: 1jqpBn1bGAHGG4x0ayPA7ii4Zoiy+PFPToMW15dsNX0A 1325826350
Date: Thu, 5 Jan 2012 21:04:28 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-ID: <20120106050428.GB7633@kroah.com>
References: <20120105182937.58ec59c2fa2bc34e9e48542a@canb.auug.org.au>
 <20120105231958.GA15643@kroah.com>
 <20120105154515.6e40fadf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105154515.6e40fadf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 03:45:15PM -0800, Andrew Morton wrote:
> On Thu, 5 Jan 2012 15:19:58 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> > On Thu, Jan 05, 2012 at 06:29:37PM +1100, Stephen Rothwell wrote:
> > > Hi Andrew,
> > > 
> > > After merging the akpm tree, today's linux-next build (powerpc
> > > ppc64_defconfig) failed like this:
> > > 
> > > drivers/base/memory.c: In function 'memory_block_change_state':
> > > drivers/base/memory.c:306:22: error: 'struct memory_block' has no member named 'sysdev'
> > > drivers/base/memory.c:309:22: error: 'struct memory_block' has no member named 'sysdev'
> > > 
> > > Caused by commit 2691cc121386 ("kdump: add udev events for memory
> > > online/offline") interacting with commit 10fbcf4c6cb1 ("convert 'memory'
> > > sysdev_class to a regular subsystem") from the driver-core tree.
> > 
> > I can't recall this kdump patch coming through before, have I seen it?
> 
> I carefully added you to the Nov 22 commit email cc list :(
> 
> > creating new uevents is not something to be done lightly, has this been
> > tested with the existing userspace tools to make sure it doesn't cause
> > problems?
> 
> Seems to be covered in the changelog:

Ah, thanks, sorry, I had forgotten about that one.  It looks good,
nevermind...

greg k-h
