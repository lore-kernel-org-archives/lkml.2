Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab1JRHmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 03:42:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46481 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab1JRHmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 03:42:43 -0400
Date: Tue, 18 Oct 2011 08:42:11 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Barry Song <21cnbao@gmail.com>,
        linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
Message-ID: <20111018074211.GA13483@flint.arm.linux.org.uk>
References: <CABE8wwsQKF9eTTU_N305hR=G5qW4Rzb7Lo-nHbc9RVYwSJVSVA@mail.gmail.com> <1317966346.1573.2252.camel@vkoul-udesk3> <CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com> <CABE8wwtcO_su0cF6YocVjAYKhUb=TTwqttfaZkC+RWGLKJimdQ@mail.gmail.com> <0CE8B6BE3C4AD74AB97D9D29BD24E55202321E20@CORPEXCH1.na.ads.idt.com> <CAJe_ZhfWcUY2ctUFt0iUf2FOfjKj1Aa8hQH5LqFG+bZ+93CcNQ@mail.gmail.com> <0CE8B6BE3C4AD74AB97D9D29BD24E55202321F65@CORPEXCH1.na.ads.idt.com> <CAJe_ZhfTg17YgyQ9TuKdhtXMu+8W_E2t3cBqZybfarxWu9Zasg@mail.gmail.com> <0CE8B6BE3C4AD74AB97D9D29BD24E552023220AC@CORPEXCH1.na.ads.idt.com> <CAJe_ZhdBSxvH6Zd8JsoLrerapNbLn0a7Lv6KxwivbFuLaSavyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJe_ZhdBSxvH6Zd8JsoLrerapNbLn0a7Lv6KxwivbFuLaSavyg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 11:15:29AM +0530, Jassi Brar wrote:
> On 18 October 2011 02:37, Bounine, Alexandre <Alexandre.Bounine@idt.com> wrote:
> > With item #1 above being a separate topic, I may have a problem with #2
> > as well: dma_addr_t is sized for the local platform and not guaranteed
> > to be a 64-bit value (which may be required by a target).
> > Agree with #3 (if #1 and #2 work).
> >
> Perhaps simply change dma_addr_t to u64 in dmaengine.h alone ?

That's just an idiotic suggestion - there's no other way to put that.
Let's have some sanity here.

dma_addr_t is the size of a DMA address for the CPU architecture being
built.  This has no relationship to what any particular DMA engine uses.

DMA addresses are likely to be stored in scatter tables in memory, and
such structures should be defined using u32, u64 (even more bonus points
if you use le32 and le64), etc and not types which are dependent on the
CPU architecture.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
