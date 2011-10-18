Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474Ab1JRRgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 13:36:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48461 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab1JRRgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 13:36:03 -0400
Date: Tue, 18 Oct 2011 18:35:21 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Barry Song <21cnbao@gmail.com>,
        linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
Message-ID: <20111018173521.GF30644@flint.arm.linux.org.uk>
References: <0CE8B6BE3C4AD74AB97D9D29BD24E55202321E20@CORPEXCH1.na.ads.idt.com> <CAJe_ZhfWcUY2ctUFt0iUf2FOfjKj1Aa8hQH5LqFG+bZ+93CcNQ@mail.gmail.com> <0CE8B6BE3C4AD74AB97D9D29BD24E55202321F65@CORPEXCH1.na.ads.idt.com> <CAJe_ZhfTg17YgyQ9TuKdhtXMu+8W_E2t3cBqZybfarxWu9Zasg@mail.gmail.com> <0CE8B6BE3C4AD74AB97D9D29BD24E552023220AC@CORPEXCH1.na.ads.idt.com> <CAJe_ZhdBSxvH6Zd8JsoLrerapNbLn0a7Lv6KxwivbFuLaSavyg@mail.gmail.com> <20111018074211.GA13483@flint.arm.linux.org.uk> <CAJe_ZhdHcsBNT6iX7TJCqoGZMrPwE2BOt06e8M8PHzuDe3Z70w@mail.gmail.com> <20111018094944.GA30644@flint.arm.linux.org.uk> <0CE8B6BE3C4AD74AB97D9D29BD24E55202367258@CORPEXCH1.na.ads.idt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E55202367258@CORPEXCH1.na.ads.idt.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 10:26:56AM -0700, Bounine, Alexandre wrote:
> On Tue, Oct 18, 2011 at 5:50 AM, Russell King <rmk@arm.linux.org.uk> wrote:
> > 3. For architectures where there are only 32-bit DMA addresses,
> > dma_addr_t
> >    will be a 32-bit type.  For architectures where there are 64-bit DMA
> >    addresses, it will be a 64-bit type.
> > 
> > 4. If RIO can accept 64-bit DMA addresses but is only connected to 32-
> > bit
> >    busses, then the top 32 address bits are not usable (it's truncated
> > in
> >    hardware.)  So there's no point passing around a 64-bit DMA address.
> 
> Existing RapidIO controllers offer an address translation mechanism for
> inbound RIO requests which will translate RIO address into an address of
> mapped endpoint's local buffer. Some less-generic endpoints may also use
> upper address bits for their own implementation specific mapping and this
> is absolutely legal from the RIO POV. As an example of similar use may be
> a PCI bus where upper AD lines are used for device selection during PCI
> configuration cycles.       
> 
> So RIO addresses of any size are not blindly truncated and cannot be ignored.

See point 3 and point 6.

However, Jassi's suggestion that we redefine dma_addr_t to be 64-bit
for just the DMA engine code is utterly insane and unworkable.  We
can't have typedefs which change depending on which bits of code are
being built, potentially changing the layout of structures being passed
around inside the kernel.

> > 6. 32-bit dma_addr_t with 64-bit DMA address space is a problem and is
> >    probably a bug in itself - the platform should be using a 64-bit
> >    dma_addr_t in this case.  (see 3.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
