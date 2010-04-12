Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0DLV5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 17:57:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:43725 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077Ab0DLV5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 17:57:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,192,1270450800"; 
   d="scan'208";a="612418183"
Date: Mon, 12 Apr 2010 14:56:57 -0700
From: Matthew Wilcox <willy@linux.intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>, Yinghai Lu <yinghai@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset
	failed (0xffffffff)
Message-ID: <20100412215657.GB19226@linux.intel.com>
References: <20100406225425.GA8292@hexapodia.org> <1270612783.8518.15.camel@dc7800.home> <201004121156.41716.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004121156.41716.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 11:56:41AM -0600, Bjorn Helgaas wrote:
> Linux thinks the windows are:
>   pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
>   pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff]
>   pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff]
> 
> The 0xa0000-0xbffff one makes good sense.  That's normally MMIO that's
> routed via PCI to the VGA device frame buffer, and we should be able
> to figure out how to avoid that area, e.g., by using BIOS info, PCI
> class codes, etc.
> 
> Now we need to figure how to avoid the 0xc0000-0xeffff and 0xf0000-0xfffff
> windows.  Maybe there's something special about how ACPI describes them.
> 
> Or maybe we're just unlucky because these are the first windows in the
> _CRS list, and Linux tries them in order, while Windows uses a different
> strategy.

Perhaps it's sufficient to try them in reverse order?
