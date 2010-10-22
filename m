Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab0JVH77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:59:59 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39156 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab0JVH74 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 22 Oct 2010 03:59:56 -0400
Message-Id: <4CC15EE9020000780001E8B5@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 22 Oct 2010 08:52:41 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <jeremy@goop.org>, <fujita.tomonori@lab.ntt.co.jp>, <hpa@linux.intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Modularizing IOMMUs (devel/iommu-0.4)
References: <20101020202006.GA30096@dumpdata.com>
In-Reply-To: <20101020202006.GA30096@dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 20.10.10 at 22:20, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> Another way, less elegant was to manually enforce each function to be stuck
> in the .iommu_text section. For that I made a macro: __iommu that would
> force the function to be stuck in section specific for the IOMMU. So all
> functions in pci-gart_64.c would be funneled in .iommu.gart.text. For 
> calgary:
> .iommu.calgary.text., and so on. This is accomplished by having at the 
> beginning
> of the the file the name of the IOMMU section, as so:
> 
> #define IOMMU_MODULE "gart"
> 
> And all of the functions would get stuck in .iommu.gart.text.

For this particular approach - did you consider using objcopy's
--rename-section option?

> And then Question  #3): Is there a better way?

Generally I like hpa's suggestion of using pre-loaded but unloadable
modules much better, not the least because in the past I had seen
potential uses for such a mechanism in other places of the kernel.

Jan

