Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab0JVNzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:55:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19331 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab0JVNzr (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 22 Oct 2010 09:55:47 -0400
Date: Fri, 22 Oct 2010 09:54:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: jeremy@goop.org, fujita.tomonori@lab.ntt.co.jp, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: Modularizing IOMMUs (devel/iommu-0.4)
Message-ID: <20101022135439.GA23030@dumpdata.com>
References: <20101020202006.GA30096@dumpdata.com>
 <4CC15EE9020000780001E8B5@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC15EE9020000780001E8B5@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 08:52:41AM +0100, Jan Beulich wrote:
> >>> On 20.10.10 at 22:20, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > Another way, less elegant was to manually enforce each function to be stuck
> > in the .iommu_text section. For that I made a macro: __iommu that would
> > force the function to be stuck in section specific for the IOMMU. So all
> > functions in pci-gart_64.c would be funneled in .iommu.gart.text. For 
> > calgary:
> > .iommu.calgary.text., and so on. This is accomplished by having at the 
> > beginning
> > of the the file the name of the IOMMU section, as so:
> > 
> > #define IOMMU_MODULE "gart"
> > 
> > And all of the functions would get stuck in .iommu.gart.text.
> 
> For this particular approach - did you consider using objcopy's
> --rename-section option?

<goes off to look at that>
> 
> > And then Question  #3): Is there a better way?
> 
> Generally I like hpa's suggestion of using pre-loaded but unloadable
> modules much better, not the least because in the past I had seen
> potential uses for such a mechanism in other places of the kernel.

<nods> It does sound like the right option. 12 years ago it was suggested,
so.. how come nobody worked on it in the past? Were there some epic battles?
