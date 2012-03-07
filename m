Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030609Ab2CGWQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:16:20 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43934 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030324Ab2CGWQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:16:19 -0500
Message-ID: <1331158573.2191.189.camel@work-vm>
Subject: Re: [PATCH 08/13] android: persistent_ram: handle reserving and
 mapping memory
From: John Stultz <john.stultz@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Date: Wed, 07 Mar 2012 14:16:13 -0800
In-Reply-To: <20120307220811.GB16652@kroah.com>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
	 <1331157503-3413-9-git-send-email-john.stultz@linaro.org>
	 <20120307220811.GB16652@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030722-5112-0000-0000-000005F8CECB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 14:08 -0800, Greg KH wrote:
> On Wed, Mar 07, 2012 at 01:58:18PM -0800, John Stultz wrote:
> > From: Colin Cross <ccross@android.com>
> > 
> > Replace the ioremapped memory passed in from the drivers with
> > a memblock_reserve and vmap.  Adds a new function,
> > persistent_ram_early_init, designed to be called from the machine
> > init_early callback, that calls memblock_remove and saves the
> > provided persistent ram area layout.
> > 
> > Drivers only pass in their struct device * and ecc settings.
> > Locating and mapping the memory is now handled entirely within
> > persistent_ram.
> > 
> > Also, convert ram_console to the new persistent_ram_init
> > parameters that only take a struct device * and ecc settings.
> > 
> > CC: Greg KH <gregkh@linuxfoundation.org>
> > CC: Android Kernel Team <kernel-team@android.com>
> > Change-Id: Ibc87ec27b70ed1c928eaa487503469e199973058
> > Change-Id: I12b018381a2ed5965a8a4b0da40c3e640f92b6cf
> > Signed-off-by: Colin Cross <ccross@android.com>
> > [jstultz: Fix pr_info casting issues on 64bit, folded two
> > patches as the build breaks if they are apart. Also replaced
> > phys_to_page() w/ pfn_to_page(addr>>PAGE_SHIFT), as phys_to_page
> > is only on a few arches.]
> 
> Please put your comments above the signed-off-by area, it makes it
> easier on tools that parse this area.

I can change it, but this is how SubmittingPatches suggests it be done:

Signed-off-by: Random J Developer <random@developer.example.org>
[lucky@maintainer.example.org: struct foo moved from foo.c to foo.h]
Signed-off-by: Lucky K Maintainer <lucky@maintainer.example.org>

thanks
-john


