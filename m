Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab0KJA6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:58:39 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:62866 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab0KJA6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:58:36 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAG982UyrR7Hu/2dsb2JhbACDOZ8CcaEMijOQe4EigzVzBIRZhX2FDw
X-IronPort-AV: E=Sophos;i="4.59,176,1288569600"; 
   d="scan'208";a="283646932"
From: Tom Lyon <pugs@cisco.com>
Organization: Cisco Systems, Inc.
To: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 0/2] vfio: virtualize INTX_DISABLE
Date: Tue, 9 Nov 2010 16:59:04 -0800
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.5-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org
References: <20101105171624.1638.33349.stgit@s20.home>
In-Reply-To: <20101105171624.1638.33349.stgit@s20.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011091659.04480.pugs@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex - I am rejecting these 2 patches.

For patch 1/2, I started with yours and found a couple of problems, but then I 
got into the spirit and did a buinch more cleaning up. My patch to follow.

For patch 2/2, the INTX stuff, I don't really see the problem.  If the user 
turns on the bit, it'll result in at most one more interrupt, right?  If he 
turns off the bit, then he doesn't want interrupts.

On Friday, November 05, 2010 10:30:15 am Alex Williamson wrote:
> Tom,
> 
> Since we use INTX_DISABLE internally for PCI 2.3 devices, it's probably
> not a good idea to allow vfio users direct access to it.  In trying to
> virtualize it, I stumbled on some config space virtualization issues.
> I think we want vconfig and the value written to hardware to be different
> when there are virtualized bits, but we lump them together.  I think this
> is why I've never been able to rely on the memory enable bit of config
> space through vfio.  With this first patch, all virtualized bits that
> are writable are sticky in vconfig.  Non-writable bits come from either
> the old value or the physical hardware depending on whether it's
> virtualized.  This means we can get rid of a lot of duplicated setting
> and reading of vconfig, and only add code for more complicated
> behaviors.  This is tricky code, to please double check that I'm not
> doing something stupid.  Thanks,
> 
> Alex
> 
> ---
> 
> Alex Williamson (2):
>       vfio: Virtualize PCI_COMMAND_INTX_DISABLE
>       vfio: Fix config space virtualization
> 
> 
>  drivers/vfio/vfio_intrs.c      |   38 ++++++++----
>  drivers/vfio/vfio_main.c       |   14 ++++
>  drivers/vfio/vfio_pci_config.c |  131
> ++++++++++++---------------------------- include/linux/vfio.h           | 
>   4 +
>  4 files changed, 84 insertions(+), 103 deletions(-)
