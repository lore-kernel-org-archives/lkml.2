Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab0JHShY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:37:24 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:55226 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab0JHShW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:37:22 -0400
Date: Fri, 8 Oct 2010 11:38:55 -0700
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2 v2] of: move phandle/ihandle into types.h and export
 to userspace
Message-ID: <20101008113855.7d37d394@debxo>
In-Reply-To: <20101008182745.GI3863@angua.secretlab.ca>
References: <20101008171210.GE3863@angua.secretlab.ca>
	<20101008.101759.193728130.davem@davemloft.net>
	<20101008173650.GH3863@angua.secretlab.ca>
	<20101008.104557.59696706.davem@davemloft.net>
	<20101008182745.GI3863@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010 12:27:45 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Fri, Oct 08, 2010 at 10:45:57AM -0700, David Miller wrote:
> > From: Grant Likely <grant.likely@secretlab.ca>
> > Date: Fri, 8 Oct 2010 11:36:50 -0600
> > 
> > > Weird.  Yeah, no other platforms expect to get a phandle type
> > > definition from the kernel headers.  The only thing driving this
> > > conversation is from arch/sparc/include/asm/Kbuild:
> > > 
> > > header-y += openprom.h
> > 
> > It was probably at one point for the sake of asm/openpromio.h but
> > that header has no dependencies on openprom.h
> > 
> > The only hit I can find in google code search, for non-kernel code,
> > is the SILO bootloader.
> > 
> > But that tree includes it's own copy of include/asm/openprom.h so
> > the actual kernel copy isn't even used.
> > 
> > I'd say we can stop exporting that header and also therefore not
> > worry about making phandle_t visible to userspace.
> 
> Yay!  That simplifies everything, and I believe it also means that the
> phandle/ihandle definitions can remain where they currently are in
> linux/of.h
> 
> Andres, can you post an updated series that includes removing
> openprom.h from the header export list?
> 

Sure, I'll just need to rework/retest the build.  I've already done
that with the openprom.h-removal patch (which was just sent).

