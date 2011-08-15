Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1HOKHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:07:43 -0400
Received: from 5.mo3.mail-out.ovh.net ([87.98.178.36]:41166 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751208Ab1HOKHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:07:42 -0400
Date: Mon, 15 Aug 2011 11:09:21 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Leo Yan <leoy@marvell.com>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Haojian Zhuang <hzhuang1@marvell.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH 1/3] ARM: mmp: add sram allocator
Message-ID: <20110815090921.GA32705@game.jcrosoft.org>
References: <1313377794-26721-1-git-send-email-leoy@marvell.com>
 <1313377794-26721-2-git-send-email-leoy@marvell.com>
 <1403041.Yj2MdIhcZO@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403041.Yj2MdIhcZO@wuerfel>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 16625600975028726532
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfedvjedrudefucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:59 Mon 15 Aug     , Arnd Bergmann wrote:
> On Monday 15 August 2011 11:09:52 Leo Yan wrote:
> > On mmp platform, there have two sram banks:
> > audio sram and internal sram. The audio sram is mainly for audio;
> > the internal sram is for video, wtm and power management.
> > So add the sram allocator using genalloc to manage them.
> > 
> > Every sram bank will register its own platform device
> > info, after the sram allocator create the generic pool
> > for the sram bank, the user module can use the pool's
> > name to get the pool handler; then it can use the handler
> > to alloc/free memory with genalloc APIs.
> > 
> > Signed-off-by: Leo Yan <leoy@marvell.com>
> > ---
> >  arch/arm/Kconfig                      |    1 +
> >  arch/arm/mach-mmp/Makefile            |    2 +-
> >  arch/arm/mach-mmp/include/mach/sram.h |   35 +++++++
> >  arch/arm/mach-mmp/sram.c              |  168 +++++++++++++++++++++++++++++++++
> >  4 files changed, 205 insertions(+), 1 deletions(-)
> >  create mode 100644 arch/arm/mach-mmp/include/mach/sram.h
> >  create mode 100644 arch/arm/mach-mmp/sram.c
> 
> Some time ago, there was talk of merging the existing sram drivers
> and creating a common driver that is easy to hook into.
> 
> What has happened with that? My feeling is that we should stop adding
> more drivers like this in the platform code but rather put an
> authoritative copy into arch/arm/mm/ or even the top-level mm/ directory
> and change over the existing drivers to hook into that one.
no need anymore I send patch to add the support of phys/virt to genalloc so
now we just have to use it

Best Regards,
J.
