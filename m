Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2KLK4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 05:56:47 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45603 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab2KLK4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 05:56:46 -0500
Date: Mon, 12 Nov 2012 10:56:41 +0000
From: Will Deacon <will.deacon@arm.com>
To: Shiraz Hashim <shiraz.hashim@st.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "spear-devel@list.st.com" <spear-devel@list.st.com>,
        "alain.pasteur@st.com" <alain.pasteur@st.com>,
        "Joerg.Wienand@sma.de" <Joerg.Wienand@sma.de>,
        "amit.goel@st.com" <amit.goel@st.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        m.szyprowski@samsung.com
Subject: Re: [PATCH] Set bit 22 in the PL310 (cache controller) AuxCtlr
 register
Message-ID: <20121112105641.GC2346@mudshark.cambridge.arm.com>
References: <1352433712-16364-1-git-send-email-shiraz.hashim@st.com>
 <20121109095400.GC2357@mudshark.cambridge.arm.com>
 <20121112064547.GN32313@localhost.localdomain>
MIME-Version: 1.0
In-Reply-To: <20121112064547.GN32313@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 12 Nov 2012 10:56:42.0758 (UTC) FILETIME=[66643A60:01CDC0C4]
X-MC-Unique: 112111210564401101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 06:45:47AM +0000, Shiraz Hashim wrote:
> On Fri, Nov 09, 2012 at 09:54:01AM +0000, Will Deacon wrote:
> > On Fri, Nov 09, 2012 at 04:01:52AM +0000, Shiraz Hashim wrote:
> > > From: Catalin Marinas <catalin.marinas@arm.com>
> > > 
> > > Clearing bit 22 in the PL310 Auxiliary Control register (shared
> > > attribute override enable) has the side effect of transforming Normal
> > > Shared Non-cacheable reads into Cacheable no-allocate reads.
> > > 
> > > Coherent DMA buffers in Linux always have a Cacheable alias via the
> > > kernel linear mapping and the processor can speculatively load cache
> > > lines into the PL310 controller. With bit 22 cleared, Non-cacheable
> > > reads would unexpectedly hit such cache lines leading to buffer
> > > corruption.
> > 
> > Is this still the case with recent kernels? I thought the dma-mapping/cma
> > work avoided the cacheable alias, but perhaps I'm mistaken.
> 
> I haven't used CMA but DMA mappings are still normal memory
> non-cacheable.

Ok, so trawling through the list reveals we only have this issue for normal
DMA mappings and not with CMA:

  http://lists.infradead.org/pipermail/linux-arm-kernel/2012-October/124276.html

I wonder whether we shouldn't just fix that, rather than work around it with
a PL310-specific hack?

Will

