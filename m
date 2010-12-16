Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab0LPRoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:44:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50795 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab0LPRoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:44:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Sin <davidsin@ti.com>
Subject: Re: [PATCH 0/9] TI DMM-TILER driver
Date: Thu, 16 Dec 2010 18:43:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org,
        Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
References: <1291674446-10766-1-git-send-email-davidsin@ti.com> <20101216172531.GG29435@lba0869738> <20101216173737.GA6767@lba0869738>
In-Reply-To: <20101216173737.GA6767@lba0869738>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012161843.48262.arnd@arndb.de>
X-Provags-ID: V02:K0:Vp+Fe1Z0m+BWSueIIa82JqaGKdRez/648AryUQN6iQF
 yifseIGr7+5ic6v5Bimb6Ab70Mhvbm0Z9/oSGMugGCbaivba61
 v21aw9CWX/eWSThhSAwWxg1s5E7QvYBPIAEBDpS8xxsAstXJGM
 DgMucTEXpgo8tq3rFN7qc66kqEBM5rkB0R61h1mO1USzbFBY2M
 VoWhl+SceoI3cuoCnL2Iw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 December 2010 18:37:38 David Sin wrote:
> I'm not sure exactly how DRM/GEM works..  What functionality do you think is 
> overlapping?  The main feature, aside from reduced page accesses, of the DMM 
> hw block is to provide physically contiguous 2 dimensional memory blocks for 
> image and video processing.  This hw sits between the interconnect and the 
> ext memory interface in the OMAP, and contains an MMU-like address traslator 
> for "virtually" physically contiguous memory and sdram pages.

As far as I can tell, both DMM and GEM at a high level manage objects
in video memory. The IOMMU that you have on the Omap hardware seems
to resemble the GART that sits between PC-style video cards and main
memory.

I don't know any details, but google quickly finds
http://lwn.net/Articles/283798/ with a description of the
initial GEM design. My main thought when looking over the
DMM code was that this should not be tied too closely to a
specific hardware, and GEM seems to be an existing abstraction
that may fit what you need.

	Arnd
