Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab1EXUgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 16:36:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab1EXUgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 16:36:03 -0400
Subject: Re: [PATCH] pci, dmar: Update dmar units devices list during
 hotplug
From: Alex Williamson <alex.williamson@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Vinod Koul <vinod.koul@intel.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        iommu@lists.linux-foundation.org,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4DDC1406.3050102@kernel.org>
References: <4DC6E569.1060808@kernel.org> <1305843308.3100.10.camel@x201>
	 <1306234696.7218.14.camel@i7.infradead.org> <1306258959.3100.79.camel@x201>
		  <4DDC0858.3090406@kernel.org> <1306267639.3100.102.camel@x201>
	  <4DDC1406.3050102@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 14:34:51 -0600
Message-ID: <1306269291.3100.106.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 13:24 -0700, Yinghai Lu wrote:
> On 05/24/2011 01:07 PM, Alex Williamson wrote:
> > On Tue, 2011-05-24 at 12:34 -0700, Yinghai Lu wrote:
> >> On 05/24/2011 10:42 AM, Alex Williamson wrote:
> >>> On Tue, 2011-05-24 at 11:58 +0100, David Woodhouse wrote:
> >>>> On Thu, 2011-05-19 at 16:15 -0600, Alex Williamson wrote:
> >>>>> I think I'd vote for saving some kind of representation of the bus
> >>>>> hierarchy, we probably don't need to list every possible individual
> >>>>> device.  Leaving a broken pointer around to be matched up and restored
> >>>>> later just seems like a continuation of an idea that was bad to begin
> >>>>> with.  Thanks, 
> >>>>
> >>>> I agree. We should just process the original ATSR information in
> >>>> dmar_find_matched_drhd_unit(), rather than comparing with a list of
> >>>> possibly stale pointers.
> >>>>
> >>>> I don't quite understand why the list of PCI devices was *ever* done
> >>>> like that.
> >>>
> >>> Yinghai,
> >>>
> >>> I thought I might be running into something similar so spent some time
> >>> taking a different slant coding up the bug you found.  Turns out I
> >>> should have tested your patch first because I wasn't hitting that bug at
> >>> all.  The patch below is a work-in-progress that I think fixes the bug
> >>> by providing a quick means of re-parsing the scope as needed to match
> >>> current struct pci_devs.  It needs testing and cleanup, but feel free to
> >>> run with it (or ignore).  Just figured its better to post than waste the
> >>> code if you end up doing something similar.  Thanks,
> >>>
> >>> Alex
> >>>
> >>
> >> it does not apply to current linus tree cleanly.
> > 
> > Sorry, for some reason I started hacking on this against a rhel kernel.
> > Here's the compile tested-only forward port to 2.6.39 (plus the
> > domain_exit flush patch).  Thanks,
> 
> can not find anywhere to call flush_unmaps_timeout(0).
> 
> so what do you mean flush patch?

Take v2.6.39, add
http://git.infradead.org/iommu-2.6.git/commitdiff/7b668357810ecb5fdda4418689d50f5d95aea6a8
and the patch below should apply cleanly.  IIRC, it doesn't touch
anything near domain_exit, so it should apply with some fuzz to stock
2.6.39 too.  Thanks,

Alex

