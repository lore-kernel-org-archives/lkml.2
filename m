Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030409Ab2HHN5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:57:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42524 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030389Ab2HHN5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:57:46 -0400
Date: Wed, 8 Aug 2012 14:57:24 +0100
From: Will Deacon <will.deacon@arm.com>
To: Cyril Chemparathy <cyril@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 00/22] Introducing the TI Keystone platform
Message-ID: <20120808135724.GC4579@mudshark.cambridge.arm.com>
References: <1343775898-28345-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343775898-28345-1-git-send-email-cyril@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyril,

On Wed, Aug 01, 2012 at 12:04:36AM +0100, Cyril Chemparathy wrote:
> This series is a follow on to the RFC series posted earlier (archived at [1]).
> The major change introduced here is the modification to the kernel patching
> mechanism for phys_to_virt/virt_to_phys, in order to support LPAE platforms
> that require late patching.  In addition to these changes, we've updated the
> series based on feedback from the earlier posting.

One thing I've noticed going through this code and also looking at the rest
of the LPAE code in mainline is that it's not at all clear what is the maximum
physical address we can support for memory.

We currently have the following restrictions:

ARM architecture: 40 bits
ARCH_PGD_SHIFT	: 38 bits
swapfile	: 36 bits (I posted some patches for this. We could
                           extend to 37 bits if we complicate the code)
SPARSEMEM	: 36 bits (due to limited number of page-flags)

It would be nice if we could define a 36-bit memory limit across the kernel
for LPAE whilst allowing higher addresses to be used for peripherals. This
also matches x86 PAE, so the common code will also work correctly.

Otherwise I worry that we will see platforms with memory right at the top of
the physical map and these will be incredibly painful to support.

Will
