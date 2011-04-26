Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1DZMpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:45:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147Ab1DZMpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:45:42 -0400
Date: Tue, 26 Apr 2011 05:45:19 -0700
From: Greg KH <gregkh@suse.de>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: Greg KH <greg@kroah.com>, Subhasish Ghosh <subhasish@mistralsolutions.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Watkins, Melissa" <m-watkins@ti.com>,
        "sachi@mistralsolutions.com" <sachi@mistralsolutions.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 08/11] tty: add pruss SUART driver
Message-ID: <20110426124519.GC5977@suse.de>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
 <1303474109-6212-9-git-send-email-subhasish@mistralsolutions.com>
 <20110425212056.GA29313@kroah.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024CAE36A6@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024CAE36A6@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 12:21:04PM +0530, Nori, Sekhar wrote:
> On Tue, Apr 26, 2011 at 02:50:56, Greg KH wrote:
> > On Fri, Apr 22, 2011 at 05:38:26PM +0530, Subhasish Ghosh wrote:
> > > This patch adds support for the TTY compliant
> > > Soft-UART device emulated on PRUSS.
> > > 
> > > This patch depends on:
> > > davinci: macro rename DA8XX_LPSC0_DMAX to DA8XX_LPSC0_PRUSS.
> > >             https://patchwork.kernel.org/patch/615681/
> 
> This is already in mainline. Plus this patch
> doesn't really seem to depend on this commit.
> 
> > > davinci: changed SRAM allocator to shared ram.
> > >             https://patchwork.kernel.org/patch/549351/
> 
> There should be no build time dependency with this patch
> (the above patch just changes which pool of SRAM the
> allocation happens from)
> 
> But, this brings out an important dependency of the patch
> calling platform specific sram allocator functions. There
> has been SRAM allocator consolidation work done by Russell
> and as a result the SRAM allocator API for DaVinci will
> actually change. The driver should probably just get sram
> space through platform data so that it doesn't depend on the
> platform specific sram allocation function.

Ok, care to fix up the code then?

> > Who is going to be applying these patches to the tree?
> > 
> > Should this driver go through a davinci subtree because of these
> > dependancies?
> 
> No, driver and platform changes can be merged separately
> if the above aspect is taken care of. Russell has been
> pushing back on merging driver patches through his tree
> unless absolutely required.

That's fine, I'll take it through my tree then, care to resolve the
above issue and resend it?

thanks,

greg k-h
