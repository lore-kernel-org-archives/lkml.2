Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1KQXbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:31:46 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:62719 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab1KQXbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:31:44 -0500
Date: Fri, 18 Nov 2011 00:30:59 +0100
From: Alessandro Rubini <ru@gnudd.com>
To: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: giancarlo.asnaghi@st.com, maddalena.brattoli@st.com, alan@linux.intel.com
Subject: a question on DMA and remapping
Message-ID: <20111117233059.GA659@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
This goes to the maintainers of x86::asm/dma-mapping.h and lib/swiotlb.c,
with Cc: to involved people.

I have an Intel evaluation board with the ST IO-Hub called STA2X11 and
I'm working to port the STA2X11 drivers to mainstream.  The code is
currently on sourceforge.  Since the device is based on a PCI-Amba
bridge, all DMA addresses are different from CPU addresses, even for
normal PCI devices, like EHCI.

Unfortunately, the current patch is changing 3 inlines to external
functions. They are dma_capable, phys_to_dma, dma_to_phys -- which
actually are only used in swiotlb.c .

I thought about the following two approaches towards a clean port:

  - using dma_supported(), which relies on dev->dma_ops->dma_supported
    and adding phys_to_dma and dma_to_phys to the dma operations. In
    the new fields, the default NULL may be used to select the current
    behaviour in an inline function.

  - copying lib/swiotlb.c to my own file, which will be almost
    identical to the existing one but for a few lines.

The former approach will have some tiny overhead on all users, besides
messing with dma_capable and dma_allowed, possibly introducing bugs in
some corner cases (but the current situation is quite messy, may I
say...)

The latter approach means code duplication, which is bad. Although
maybe over time I may be able to shrink the current swiotlb.c to a
much smaller snippet. I tend to prefer this one, but I'm not sure if
it's acceptable.

Any feedback is welcome. Thanks in advance.

/alessandro
