Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1HQM5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 08:57:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:46784 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989Ab1HQM5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 08:57:46 -0400
Date: Wed, 17 Aug 2011 14:32:21 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Leo Yan <leoy@marvell.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Haojian Zhuang <hzhuang1@marvell.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH V4 0/3] ARM: mmp: add audio sram support
Message-ID: <20110817123221.GH28201@game.jcrosoft.org>
References: <1313377794-26721-1-git-send-email-leoy@marvell.com>
 <1313377893.14434.5.camel@Lily>
 <CAMPhdO8rkct4H74zXBzaDa183u5vrPArerXgiNXwvQWzZT67Ng@mail.gmail.com>
 <20110815091245.GC32705@game.jcrosoft.org>
 <CAMPhdO_StSa9fsYLNjJDd0KDkUyg6ep3gN2n5Gx-WmZ8t=bTFw@mail.gmail.com>
 <4E48F420.3030101@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E48F420.3030101@marvell.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13355706171265297210
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfedvkedrtdduucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddm
X-Greylist: Delayed for 51:20:00 by milter-greylist-4.2.6 (hera.kernel.org [140.211.167.34]); Wed, 17 Aug 2011 12:57:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:25 Mon 15 Aug     , Leo Yan wrote:
> 
> 
> On 08/15/2011 05:35 PM, Eric Miao wrote:
> >On Mon, Aug 15, 2011 at 5:12 PM, Jean-Christophe PLAGNIOL-VILLARD
> ><plagnioj@jcrosoft.com>  wrote:
> >>On 16:43 Mon 15 Aug     , Eric Miao wrote:
> >>>On Mon, Aug 15, 2011 at 11:11 AM, Haojian Zhuang
> >>><haojian.zhuang@marvell.com>  wrote:
> >>>>On Sun, 2011-08-14 at 20:09 -0700, Leo Yan wrote:
> >>>>>On mmp platform, there have two sram banks:
> >>>>>audio sram bank, and internal sram bank for video and PM.
> >>>>>So add the sram module to manage these sram banks.
> >>>>>
> >>>>>And register the sram banks so can dynamically alloc/free
> >>>>>the buffer.
> >>>>>
> >>>>>Leo Yan (3):
> >>>>>   ARM: mmp: add sram allocator
> >>>>>   ARM: mmp: register audio sram bank
> >>>>>   ARM: mmp: register internal sram bank
> >>>>>
> >>>>>  arch/arm/Kconfig                      |    1 +
> >>>>>  arch/arm/mach-mmp/Makefile            |    2 +-
> >>>>>  arch/arm/mach-mmp/brownstone.c        |   11 ++
> >>>>>  arch/arm/mach-mmp/include/mach/mmp2.h |   13 +++
> >>>>>  arch/arm/mach-mmp/include/mach/sram.h |   35 +++++++
> >>>>>  arch/arm/mach-mmp/mmp2.c              |    3 +
> >>>>>  arch/arm/mach-mmp/sram.c              |  168 +++++++++++++++++++++++++++++++++
> >>>>>  7 files changed, 232 insertions(+), 1 deletions(-)
> >>>>>  create mode 100644 arch/arm/mach-mmp/include/mach/sram.h
> >>>>>  create mode 100644 arch/arm/mach-mmp/sram.c
> >>>>>
> >>>>Acked-by: Haojian Zhuang<haojian.zhuang@gmail.com>
> >>>
> >>>Looks good to me. Thanks Haojian. Applied to -devel.
> >>I've some reserve on the named pool they need to be managed at generic level
> >>not here
> >
> >What are their names? And your suggestions to fix this?
> >
> 
> For MMP platform have not only one bank, so now named the audio sram
> bank as "asram", and another sram bank as "isram" which is used by
> video/secure processor/pm.
> If other modules want to use the sram, just use the name string to
> get the gen pool handler, and then just call genalloc APIs.
> 
> I just wander if maintain the name in genalloc, then the name string
> we should maintain in the pool's structure or chunk's structure?
on the chunk

Best Regards,
J.
