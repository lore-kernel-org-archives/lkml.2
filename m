Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab0HBNk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 09:40:59 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:37126 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab0HBNk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 09:40:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reply-To: konrad.wilk@oracle.com
Organization: Oracle
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] swiotlb: enlarge iotlb buffer on demand
Date: Mon, 2 Aug 2010 09:40:08 -0400
User-Agent: KMail/1.9.10
Cc: konrad@kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, ak@linux.intel.com, akataria@vmware.com
References: <20100731003643E.fujita.tomonori@lab.ntt.co.jp> <20100731010706.GA30319@andromeda.dapyr.net> <20100801120224F.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100801120224F.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008020940.09552.konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 July 2010 23:03:11 FUJITA Tomonori wrote:
> On Fri, 30 Jul 2010 21:07:06 -0400
>
> Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:
> > I took your patch and was trying to fit it over the
> > stable/swiotlb-0.8.4 branch and when I did so a found couple of things..
> >
> > > > @@ -215,14 +222,14 @@ swiotlb_late_init_with_default_size(size_t
> > > > default_size) bytes = io_tlb_nslabs << IO_TLB_SHIFT;
> >
> > You should also initialize the __io_tlb_start array first:
>
> Yeah, I know. As I wrote, this patchset breaks IA64.
>
> I really merge to swiotlb's two memory allocator mechanisms
> (swiotlb_init_with_default_size and
> swiotlb_late_init_with_default_size). I need to look at the x86 memory
> boot code after memblock surgery finishes.

<nods>
>
> And as you know, I've not fixed the error path and swiotlb_free. I'll
> do later if people are not against swiotlb dynamic allocation.

It looks to me like it would be a good patch.

I am curious about the handling of the -ENOMEM stage. Naturally we would 
return an error the device - are the most common ones (ahci, r8169, 
ata_piix - those that are DMA_32) equipped to deal with unavailable memory?
