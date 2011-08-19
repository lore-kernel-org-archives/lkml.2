Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab1HSI03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 04:26:29 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:38588 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751857Ab1HSI0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 04:26:24 -0400
Subject: Re: [PATCH V4 0/3] ARM: mmp: add audio sram support
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Leo Yan <leoy@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
        "Haojian Zhuang" <hzhuang1@marvell.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20110817123221.GH28201@game.jcrosoft.org>
References: <1313377794-26721-1-git-send-email-leoy@marvell.com>
	 <1313377893.14434.5.camel@Lily>
	 <CAMPhdO8rkct4H74zXBzaDa183u5vrPArerXgiNXwvQWzZT67Ng@mail.gmail.com>
	 <20110815091245.GC32705@game.jcrosoft.org>
	 <CAMPhdO_StSa9fsYLNjJDd0KDkUyg6ep3gN2n5Gx-WmZ8t=bTFw@mail.gmail.com>
	 <4E48F420.3030101@marvell.com>  <20110817123221.GH28201@game.jcrosoft.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Aug 2011 16:25:55 +0800
Message-ID: <1313742355.2043.8.camel@Lily>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 05:32 -0700, Jean-Christophe PLAGNIOL-VILLARD
wrote:
> On 18:25 Mon 15 Aug     , Leo Yan wrote:
> > 
> > 
> > On 08/15/2011 05:35 PM, Eric Miao wrote:
> > >On Mon, Aug 15, 2011 at 5:12 PM, Jean-Christophe PLAGNIOL-VILLARD
> > ><plagnioj@jcrosoft.com>  wrote:
> > >>On 16:43 Mon 15 Aug     , Eric Miao wrote:
> > >>>On Mon, Aug 15, 2011 at 11:11 AM, Haojian Zhuang
> > >>><haojian.zhuang@marvell.com>  wrote:
> > >>>>On Sun, 2011-08-14 at 20:09 -0700, Leo Yan wrote:
> > >>>>>On mmp platform, there have two sram banks:
> > >>>>>audio sram bank, and internal sram bank for video and PM.
> > >>>>>So add the sram module to manage these sram banks.
> > >>>>>
> > >>>>>And register the sram banks so can dynamically alloc/free
> > >>>>>the buffer.
> > >>>>>
> > >>>>>Leo Yan (3):
> > >>>>>   ARM: mmp: add sram allocator
> > >>>>>   ARM: mmp: register audio sram bank
> > >>>>>   ARM: mmp: register internal sram bank
> > >>>>>
> > >>>>>  arch/arm/Kconfig                      |    1 +
> > >>>>>  arch/arm/mach-mmp/Makefile            |    2 +-
> > >>>>>  arch/arm/mach-mmp/brownstone.c        |   11 ++
> > >>>>>  arch/arm/mach-mmp/include/mach/mmp2.h |   13 +++
> > >>>>>  arch/arm/mach-mmp/include/mach/sram.h |   35 +++++++
> > >>>>>  arch/arm/mach-mmp/mmp2.c              |    3 +
> > >>>>>  arch/arm/mach-mmp/sram.c              |  168 +++++++++++++++++++++++++++++++++
> > >>>>>  7 files changed, 232 insertions(+), 1 deletions(-)
> > >>>>>  create mode 100644 arch/arm/mach-mmp/include/mach/sram.h
> > >>>>>  create mode 100644 arch/arm/mach-mmp/sram.c
> > >>>>>
> > >>>>Acked-by: Haojian Zhuang<haojian.zhuang@gmail.com>
> > >>>
> > >>>Looks good to me. Thanks Haojian. Applied to -devel.
> > >>I've some reserve on the named pool they need to be managed at generic level
> > >>not here
> > >
> > >What are their names? And your suggestions to fix this?
> > >
> > 
> > For MMP platform have not only one bank, so now named the audio sram
> > bank as "asram", and another sram bank as "isram" which is used by
> > video/secure processor/pm.
> > If other modules want to use the sram, just use the name string to
> > get the gen pool handler, and then just call genalloc APIs.
> > 
> > I just wander if maintain the name in genalloc, then the name string
> > we should maintain in the pool's structure or chunk's structure?
> on the chunk
> 
> Best Regards,
> J.

Now two sram region are used in one silicon. They are routed for
different functionality. If they're defined into chunks in same gen
pool, driver can't specify memory in which sram region. It's not our
target. And I don't think that we need to change gen pool to support
allocating memory into specified chunk. Since it's unnecessary.

So I think that these two sram region should be defined into two pools,
not two chunks. What's your opinion?

Thanks
Haojian

