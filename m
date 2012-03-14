Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761315Ab2CNRsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:48:25 -0400
Received: from sous-sol.org ([216.99.217.87]:52646 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761133Ab2CNRsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:48:23 -0400
Date: Wed, 14 Mar 2012 10:48:07 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org
Subject: Re: trying to figure out why VT-d isn't working on my kernel --
 solved
Message-ID: <20120314174807.GB27235@sequoia.sous-sol.org>
References: <4F56E728.8020506@genband.com>
 <4F593792.1070909@genband.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F593792.1070909@genband.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Friesen (chris.friesen@genband.com) wrote:
> On 03/06/2012 10:42 PM, Chris Friesen wrote:
> >I've got a current (pulled today) kernel running on a Xeon E5-2648L CPU
> >on an Intel motherboard, and I'm trying to get VT-d working without much success.
> >
> >lspci -vv (version 3.1.4) doesn't show anything related to IOV.
> >(Full output below.)  Since I know the I350 devices are capable of virtual
> >functions, am I correct in assuming it's something similar to the situation
> >described at https://bugzilla.redhat.com/show_bug.cgi?id=652210 and there is
> >a problem with my BIOS?  Based on comment 15 there, the fact that all
> >the DevCtl2 lines show "ARIFwd-" seems interesting.
> >
> >Among other things, I've enabled the following in the kernel config:
> >
> >CONFIG_DMAR_TABLE=y
> >CONFIG_INTEL_IOMMU=y
> >CONFIG_INTEL_IOMMU_DEFAULT_ON=y
> >CONFIG_PCI_MSI=y
> >CONFIG_PCI_STUB=y
> >CONFIG_PCI_IOV=y
> 
> Just in case anyone else runs into this, it turns out that enabling
> CONFIG_PCI_MMCONFIG allowed the virtual functions to be detected and
> configured.

Yeah, you need to be able to access PCI Extended Configuration Space to
enable SR-IOV.

thanks,
-chris
