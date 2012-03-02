Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab2CBUId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:08:33 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:51446 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab2CBUIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:08:31 -0500
Date: Fri, 2 Mar 2012 21:08:26 +0100
From: Bastian Blank <waldi@debian.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, xen-devel@lists.xensource.com,
        pkg-xen-devel@lists.alioth.debian.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        linux-kernel@vger.kernel.org, William Dauchy <wdauchy@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Dave Jiang <dave.jiang@intel.com>
Subject: Re: [Pkg-xen-devel] ioatdma: Boot process hangs then reboots when
 using Xen + Linux 3.2
Message-ID: <20120302200826.GA4728@wavehammer.waldi.eu.org>
Mail-Followup-To: Dan Williams <dan.j.williams@intel.com>,
	Jonathan Nieder <jrnieder@gmail.com>, xen-devel@lists.xensource.com,
	pkg-xen-devel@lists.alioth.debian.org,
	Maciej Sosnowski <maciej.sosnowski@intel.com>,
	linux-kernel@vger.kernel.org, William Dauchy <wdauchy@gmail.com>,
	Konrad Rzeszutek Wilk <konrad@darnok.org>,
	Dave Jiang <dave.jiang@intel.com>
References: <20120127144737.GA27750@andromeda.dapyr.net>
 <20120219223125.GA820@burratino>
 <20120220181618.GD17566@burratino>
 <4F4891B8.9050008@goirand.fr>
 <20120302055715.GA692@burratino>
 <CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>
 <20120302162159.GB31683@wavehammer.waldi.eu.org>
 <CABE8wwtrMEAMw3sJgb8XWQWn_N=YOPzhNbLL0kzMKLhv7xt5=A@mail.gmail.com>
 <20120302175719.GA1468@wavehammer.waldi.eu.org>
 <CABE8wwvd-R1VkyFL-eZYDB9O05zyWkVQ8pXuMb8GcdAW=5qT3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABE8wwvd-R1VkyFL-eZYDB9O05zyWkVQ8pXuMb8GcdAW=5qT3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 11:31:56AM -0800, Dan Williams wrote:
> On Fri, Mar 2, 2012 at 9:57 AM, Bastian Blank <waldi@debian.org> wrote:
> > phys_complete (a 32 bit value) gets compared to struct
> > dma_async_tx_descriptor.phys, which is defined as dma_addr_t, a _64_ bit
> > value.
> The assumption is that the driver's control structures are not in high
> memory so all address values will only have 32-bits of valid data,

Can you back that up by some kernel documentation? There is a reason why
pci_alloc_pool uses dma_addr_t to store the address and _not_ unsigned
long. This are physical addresses, nothing the kernel can access
directly without a mapping.

>                                                                    but
> maybe xen32 changes that assumption?

Xen changes a lot of things in the memory management. This includes that
physical != machine addresses, where i915 failed horrible.

> Can you send the log of the driver load with debug enabled?

No, I don't have that hardware.

Bastian

-- 
Each kiss is as the first.
		-- Miramanee, Kirk's wife, "The Paradise Syndrome",
		   stardate 4842.6
