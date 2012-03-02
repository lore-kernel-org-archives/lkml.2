Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab2CBVRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:17:13 -0500
Received: from mga05.intel.com ([192.55.52.89]:21678 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932142Ab2CBVRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:17:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dan.j.williams@intel.com designates 10.182.109.106 as permitted sender) smtp.mail=dan.j.williams@intel.com
MIME-Version: 1.0
In-Reply-To: <20120302205600.GB4728@wavehammer.waldi.eu.org>
References: <20120220181618.GD17566@burratino>
	<4F4891B8.9050008@goirand.fr>
	<20120302055715.GA692@burratino>
	<CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>
	<20120302162159.GB31683@wavehammer.waldi.eu.org>
	<CABE8wwtrMEAMw3sJgb8XWQWn_N=YOPzhNbLL0kzMKLhv7xt5=A@mail.gmail.com>
	<20120302175719.GA1468@wavehammer.waldi.eu.org>
	<CABE8wwvd-R1VkyFL-eZYDB9O05zyWkVQ8pXuMb8GcdAW=5qT3A@mail.gmail.com>
	<20120302200826.GA4728@wavehammer.waldi.eu.org>
	<CABE8wwvKC0k=nS8SU3vRyUQVBA=WgnsxbNOnGyy9dFNQLshdvA@mail.gmail.com>
	<20120302205600.GB4728@wavehammer.waldi.eu.org>
Date: Fri, 2 Mar 2012 13:17:07 -0800
Message-ID: <CABE8wwtqg5eOqW19EBX+bhq2Gz6O8V6JHVgEB+zeBWpr1D92tw@mail.gmail.com>
Subject: Re: [Pkg-xen-devel] ioatdma: Boot process hangs then reboots when
 using Xen + Linux 3.2
From: Dan Williams <dan.j.williams@intel.com>
To: Dan Williams <dan.j.williams@intel.com>,
        Jonathan Nieder <jrnieder@gmail.com>, xen-devel@lists.xensource.com,
        pkg-xen-devel@lists.alioth.debian.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        linux-kernel@vger.kernel.org, William Dauchy <wdauchy@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 12:56 PM, Bastian Blank <waldi@debian.org> wrote:
> On Fri, Mar 02, 2012 at 12:16:47PM -0800, Dan Williams wrote:
>> On Fri, Mar 2, 2012 at 12:08 PM, Bastian Blank <waldi@debian.org> wrote:
>> > On Fri, Mar 02, 2012 at 11:31:56AM -0800, Dan Williams wrote:
>> >> On Fri, Mar 2, 2012 at 9:57 AM, Bastian Blank <waldi@debian.org> wrote:
>> >> > phys_complete (a 32 bit value) gets compared to struct
>> >> > dma_async_tx_descriptor.phys, which is defined as dma_addr_t, a _64_ bit
>> >> > value.
>> >> The assumption is that the driver's control structures are not in high
>> >> memory so all address values will only have 32-bits of valid data,
>> > Can you back that up by some kernel documentation? There is a reason why
>> > pci_alloc_pool uses dma_addr_t to store the address and _not_ unsigned
>> > long. This are physical addresses, nothing the kernel can access
>> > directly without a mapping.
>> High memory can only be accessed with kmap(), so the assumption is
>> that dma_alloc never gives a buffer address above 32-bits on a 32-bit
>> build.  Yes, if HIGHMEM64G is set dma_addr_t becomes 64-bit, but that
>> is only to access high memory mapped application buffers via dma_map.
>
> All memory needs to be mapped.  Linux just have a default mapping of 1GiB
> of the memory handy. However this is irrelevant for the physical DMA
> addresses we talk about.

I'm not sure you understand how himem works or we're talking past each other.
