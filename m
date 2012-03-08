Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab2CHBqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 20:46:13 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37137 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190Ab2CHBqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 20:46:12 -0500
X-Sasl-enc: TGEn8ivSvcuzBSPhn6ZUDqXtXdPFDn48EHl8cRpCd1Wu 1331171171
Date: Wed, 7 Mar 2012 17:46:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 08/13] android: persistent_ram: handle reserving and
 mapping memory
Message-ID: <20120308014610.GA2297@kroah.com>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
 <1331157503-3413-9-git-send-email-john.stultz@linaro.org>
 <20120307220811.GB16652@kroah.com>
 <1331158573.2191.189.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331158573.2191.189.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 02:16:13PM -0800, John Stultz wrote:
> On Wed, 2012-03-07 at 14:08 -0800, Greg KH wrote:
> > On Wed, Mar 07, 2012 at 01:58:18PM -0800, John Stultz wrote:
> > > From: Colin Cross <ccross@android.com>
> > > 
> > > Replace the ioremapped memory passed in from the drivers with
> > > a memblock_reserve and vmap.  Adds a new function,
> > > persistent_ram_early_init, designed to be called from the machine
> > > init_early callback, that calls memblock_remove and saves the
> > > provided persistent ram area layout.
> > > 
> > > Drivers only pass in their struct device * and ecc settings.
> > > Locating and mapping the memory is now handled entirely within
> > > persistent_ram.
> > > 
> > > Also, convert ram_console to the new persistent_ram_init
> > > parameters that only take a struct device * and ecc settings.
> > > 
> > > CC: Greg KH <gregkh@linuxfoundation.org>
> > > CC: Android Kernel Team <kernel-team@android.com>
> > > Change-Id: Ibc87ec27b70ed1c928eaa487503469e199973058
> > > Change-Id: I12b018381a2ed5965a8a4b0da40c3e640f92b6cf
> > > Signed-off-by: Colin Cross <ccross@android.com>
> > > [jstultz: Fix pr_info casting issues on 64bit, folded two
> > > patches as the build breaks if they are apart. Also replaced
> > > phys_to_page() w/ pfn_to_page(addr>>PAGE_SHIFT), as phys_to_page
> > > is only on a few arches.]
> > 
> > Please put your comments above the signed-off-by area, it makes it
> > easier on tools that parse this area.
> 
> I can change it, but this is how SubmittingPatches suggests it be done:
> 
> Signed-off-by: Random J Developer <random@developer.example.org>
> [lucky@maintainer.example.org: struct foo moved from foo.c to foo.h]
> Signed-off-by: Lucky K Maintainer <lucky@maintainer.example.org>

Oops, you are right, nevermind then.  But the change-id stuff needs to
still go.

thanks,

greg k-h
