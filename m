Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab2JOQ42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:56:28 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:52019 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab2JOQ41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:56:27 -0400
Date: Mon, 15 Oct 2012 10:56:18 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter.Huewe@infineon.com, key@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH] TPM: Let the tpm char device be openable
 multiple times
Message-ID: <20121015165618.GA375@obsidianresearch.com>
References: <20120930233345.GJ30637@obsidianresearch.com>
 <20121010163324.GB5013@ennui.austin.ibm.com>
 <20121012205658.GM4124@obsidianresearch.com>
 <74A44E99E3274B4CB570415926B37D440ED140@MUCSE501.eu.infineon.com>
 <20121015163945.GA32563@obsidianresearch.com>
 <20121015174922.31fbadd9@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121015174922.31fbadd9@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 05:49:22PM +0100, Alan Cox wrote:

> > > > Using open/close is an interesting idea, but it wouldn't work. open()
> > > > is coded to return EBUSY if another process has it open, rather than
> > > > block, and spinning on open would be unacceptable.
> > > 
> > > Hmm, maybe write a small pass through program which opens /dev/tpm
> > > once and accepts its data via a socket or pipe?
> > 
> > I believe the kernel should not be enforcing this kind of policy into
> > userspace. Plus, some of our embedded system are memory constrained
> > so an unnecessary process is not welcome..
> 
> Sane device drivers for devices where contention is meaningful block on
> an open that is busy, or return an error if the O_NONBLOCK option is
> specified. That's the normal case.

We have here a situation where there is no kernel or hardware
requirement for exclusivity, but the current driver enforces it, for
userspace only. Today the kernel and user space can access the TPM
device concurrently.

So, I would like to migrate the userspace interface to allow
non-exclusivity, but how do we do this?

Jason
