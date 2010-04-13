Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0DMBwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 21:52:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34459 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab0DMBwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 21:52:06 -0400
Message-ID: <4BC3CE31.2000100@zytor.com>
Date: Mon, 12 Apr 2010 18:51:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset failed
 (0xffffffff)
References: <20100406225425.GA8292@hexapodia.org> <1270612783.8518.15.camel@dc7800.home> <201004121156.41716.bjorn.helgaas@hp.com>
In-Reply-To: <201004121156.41716.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 10:56 AM, Bjorn Helgaas wrote:
> 
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
> 

I strongly suspects that Windows knows that < 1 MB is special, and only
ever assigns it upon explicit allocation.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

