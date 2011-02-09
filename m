Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab1BIRDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:03:31 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:38703 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab1BIRDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:03:30 -0500
Date: Wed, 9 Feb 2011 09:03:27 -0800
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: David Laight <David.Laight@ACULAB.COM>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] misc: add CARMA DATA-FPGA Access Driver
Message-ID: <20110209170327.GA21766@ovro.caltech.edu>
References: <1297121021-3522-2-git-send-email-iws@ovro.caltech.edu>
 <AE90C24D6B3A694183C094C60CF0A2F6D8AC45@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AC45@saturn3.aculab.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Wed, 09 Feb 2011 09:03:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 04:30:23PM -0000, David Laight wrote:
>  
> > This driver allows userspace to access the data processing 
> > FPGAs on the OVRO CARMA board. It has two modes of operation:
> > 
> > 1) random access
> > 
> > This allows users to poke any DATA-FPGA registers by using mmap to map
> > the address region directly into their memory map.
> 
> I needed something similar, but used pread() and pwrite()
> to request the transfers.
> While this does require a system call per transfer, it allows
> the driver to use dma (if available) to speed up the request.
> In my case doing single cycle transfers would be too slow.
> 

We initially started with a read()/write() interface for individual
register reads and writes, just like you describe. It turned out that
mmap was plenty fast for our use. I made the decision to ditch all of
the extra code needed to setup and execute the DMA for the much simpler
mmap code.

In our case, going all the way through the DMA engine code just to
transfer 4 bytes is overkill. The local bus is already quite fast, and
we can increase the clock speed if needed.

Ira
