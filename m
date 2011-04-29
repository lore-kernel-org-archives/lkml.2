Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab1D2Sa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:30:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54417 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760811Ab1D2SaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:30:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        KyongHo Cho <pullip.cho@samsung.com>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Date: Fri, 29 Apr 2011 20:29:50 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>
References: <201104212129.17013.arnd@arndb.de> <20110429075958.GV17290@n2100.arm.linux.org.uk> <20110429093209.1926c732@jbarnes-desktop>
In-Reply-To: <20110429093209.1926c732@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104292029.50680.arnd@arndb.de>
X-Provags-ID: V02:K0:0nAAP/s01CtLw2p1NYv1z6PkuGsBVTzQaTFEJgj+D9L
 ICPfsQOaZx/8U+7XTyY2IaltBGstKef2xTdINM/MSaX3LdgdvG
 0VTRGX/3sH/vl65/n9w+6mtUKlSKKsxErSpzd9wDmnufiJ+jZ9
 wrh6X/WTFQBhq+D46RgHysv8hdulU+1myn/r+hD6yCJp3LOb2i
 oUEr9VXELQKpchznFml6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 April 2011 18:32:09 Jesse Barnes wrote:
> On Fri, 29 Apr 2011 08:59:58 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Fri, Apr 29, 2011 at 07:50:12AM +0200, Thomas Hellstrom wrote:
> > > However, we should be able to construct a completely generic api around  
> > > these operations, and for architectures that don't support them we need  
> > > to determine
> > >
> > > a)  Whether we want to support them anyway (IIRC the problem with PPC is  
> > > that the linear kernel map has huge tlb entries that are very  
> > > inefficient to break up?)
> > 
> > That same issue applies to ARM too - you'd need to stop the entire
> > machine, rewrite all processes page tables, flush tlbs, and only
> > then restart.  Otherwise there's the possibility of ending up with
> > conflicting types of TLB entries, and I'm not sure what the effect
> > of having two matching TLB entries for the same address would be.
> 
> Right, I don't think anyone wants to see this sort of thing happen with
> any frequency.  So either a large, uncached region can be set up a boot
> time for allocations, or infrequent, large requests and conversions can
> be made on demand, with memory being freed back to the main, coherent
> pool under pressure.

I'd like to first have an official confirmation from the CPU designers
if there is actually a problem with mapping a single page both cacheable
and noncacheable. Based on what Catalin said, it's probably allowed and
the current spec is just being more paranoid than it needs to be. Also,
KyongHo Cho said that it might only be relevant for pages that are mapped
executable.

If that is the case, we can probably work around this by turning the entire
linear mapping (except for the kernel binary) into nonexecutable mode,
if we don't do that already.
This is desirable for security purposes anyway.

	Arnd
