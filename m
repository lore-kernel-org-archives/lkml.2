Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab1LEOVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 09:21:44 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53574 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab1LEOVn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 09:21:43 -0500
MIME-Version: 1.0
X-Originating-IP: [67.207.136.126]
In-Reply-To: <20111115103926.GA5627@amd.com>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com> <20111115103926.GA5627@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 5 Dec 2011 16:21:21 +0200
Message-ID: <CAK=WgbY18K00DRcmP56+UJrmMu5h_O=GaO+i_GzbC5SzCvrnRA@mail.gmail.com>
Subject: Re: [RFC 0/5] OMAP groundwork for IOMMU-based DMA API
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cousson Benoit <b-cousson@ti.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Tue, Nov 15, 2011 at 12:39 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> On Sun, Sep 25, 2011 at 06:58:52AM -0400, Ohad Ben-Cohen wrote:
>> Ohad Ben-Cohen (5):
>>   ARM: dev_archdata: add private iommu extension
>>   ARM: OMAP: omap_device: add a method to set iommu private archdata
>>   ARM: OMAP: iommu: declare a private iommu binding struct
>>   ARM: OMAP3: bind omap3isp_device to its iommu device
>>   iommu/omap: eliminate the public omap_find_iommu_device() method
>
> It doesn't apply cleanly, can you please rebase the code, collect the
> Acked-by's and resend?

I have collected Tony's and Laurent's Acked-by's and amended them to
the commit logs.

I have also made sure it applies cleanly to a recent 3.2, and tested
it with OMAP4/remoteproc. I couldn't test it with omap3isp though,
because I'm gated by (what looks like a) 3.2 omap3isp regression (see
http://www.spinics.net/lists/linux-omap/msg60510.html). I did test it
of course with omap3isp and 3.1, so I don't expect any omap3isp/iommu
issues with these patches. Anyway, when the omap3isp issue will be
resolved I'll make sure there isn't any iommu regression.

Please pull, thanks a lot!

The following changes since commit cfcfc9eca2bcbd26a8e206baeb005b055dbf8e37:

  Linux 3.2-rc2 (2011-11-15 15:02:59 -0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/linux.git for-joerg

Ohad Ben-Cohen (3):
      ARM: OMAP: iommu: declare a private iommu binding struct
      ARM: OMAP3: bind omap3isp_device to its iommu device
      iommu/omap: eliminate the public omap_find_iommu_device() method

 arch/arm/mach-omap2/devices.c           |    7 ++++
 arch/arm/plat-omap/include/plat/iommu.h |   31 +++++++++++++++--
 arch/arm/plat-omap/include/plat/iovmm.h |   12 +++---
 drivers/iommu/omap-iommu.c              |   58 ++++++++++++++-----------------
 drivers/iommu/omap-iovmm.c              |   31 +++++++++++------
 drivers/media/video/omap3isp/isp.c      |   30 +++-------------
 drivers/media/video/omap3isp/isp.h      |    2 -
 drivers/media/video/omap3isp/ispccdc.c  |   18 +++++-----
 drivers/media/video/omap3isp/ispstat.c  |    8 ++--
 drivers/media/video/omap3isp/ispvideo.c |    4 +-
 10 files changed, 107 insertions(+), 94 deletions(-)
