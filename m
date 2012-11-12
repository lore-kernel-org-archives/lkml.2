Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab2KLHKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 02:10:07 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:44836 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169Ab2KLHKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 02:10:05 -0500
Date: Mon, 12 Nov 2012 12:15:47 +0530
From: Shiraz Hashim <shiraz.hashim@st.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "spear-devel@list.st.com" <spear-devel@list.st.com>,
        "alain.pasteur@st.com" <alain.pasteur@st.com>,
        "Joerg.Wienand@sma.de" <Joerg.Wienand@sma.de>, <amit.goel@st.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Set bit 22 in the PL310 (cache controller) AuxCtlr
 register
Message-ID: <20121112064547.GN32313@localhost.localdomain>
References: <1352433712-16364-1-git-send-email-shiraz.hashim@st.com>
 <20121109095400.GC2357@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121109095400.GC2357@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 09:54:01AM +0000, Will Deacon wrote:
> On Fri, Nov 09, 2012 at 04:01:52AM +0000, Shiraz Hashim wrote:
> > From: Catalin Marinas <catalin.marinas@arm.com>
> > 
> > Clearing bit 22 in the PL310 Auxiliary Control register (shared
> > attribute override enable) has the side effect of transforming Normal
> > Shared Non-cacheable reads into Cacheable no-allocate reads.
> > 
> > Coherent DMA buffers in Linux always have a Cacheable alias via the
> > kernel linear mapping and the processor can speculatively load cache
> > lines into the PL310 controller. With bit 22 cleared, Non-cacheable
> > reads would unexpectedly hit such cache lines leading to buffer
> > corruption.
> 
> Is this still the case with recent kernels? I thought the dma-mapping/cma
> work avoided the cacheable alias, but perhaps I'm mistaken.

I haven't used CMA but DMA mappings are still normal memory
non-cacheable.

--
regards
Shiraz
