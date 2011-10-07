Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1JGTHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 15:07:03 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:29668 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab1JGTHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 15:07:01 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18+ze3HjdyngRB4SAWcYb3d
Date: Fri, 7 Oct 2011 12:06:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Leo Yan <leoy@marvell.com>,
        linux-kernel@vger.kernel.org, Haojian Zhuang <hzhuang1@marvell.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: mmp: add sram allocator
Message-ID: <20111007190654.GM6324@atomide.com>
References: <1313377794-26721-1-git-send-email-leoy@marvell.com>
 <1313377794-26721-2-git-send-email-leoy@marvell.com>
 <1403041.Yj2MdIhcZO@wuerfel>
 <20110815090921.GA32705@game.jcrosoft.org>
 <CAN1soZwz4Wj+rAqnLBGRqY0N2keFgxGYJw8sKEzsssjhLn-gSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN1soZwz4Wj+rAqnLBGRqY0N2keFgxGYJw8sKEzsssjhLn-gSw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Haojian Zhuang <haojian.zhuang@gmail.com> [110815 01:57]:
> On Mon, Aug 15, 2011 at 5:09 PM, Jean-Christophe PLAGNIOL-VILLARD
> <plagnioj@jcrosoft.com> wrote:
> > On 10:59 Mon 15 Aug     , Arnd Bergmann wrote:
> >> On Monday 15 August 2011 11:09:52 Leo Yan wrote:
> >> > On mmp platform, there have two sram banks:
> >> > audio sram and internal sram. The audio sram is mainly for audio;
> >> > the internal sram is for video, wtm and power management.
> >> > So add the sram allocator using genalloc to manage them.
> >> >
> >> > Every sram bank will register its own platform device
> >> > info, after the sram allocator create the generic pool
> >> > for the sram bank, the user module can use the pool's
> >> > name to get the pool handler; then it can use the handler
> >> > to alloc/free memory with genalloc APIs.
> >> >
> >> > Signed-off-by: Leo Yan <leoy@marvell.com>
> >> > ---
> >> >  arch/arm/Kconfig                      |    1 +
> >> >  arch/arm/mach-mmp/Makefile            |    2 +-
> >> >  arch/arm/mach-mmp/include/mach/sram.h |   35 +++++++
> >> >  arch/arm/mach-mmp/sram.c              |  168 +++++++++++++++++++++++++++++++++
> >> >  4 files changed, 205 insertions(+), 1 deletions(-)
> >> >  create mode 100644 arch/arm/mach-mmp/include/mach/sram.h
> >> >  create mode 100644 arch/arm/mach-mmp/sram.c
> >>
> >> Some time ago, there was talk of merging the existing sram drivers
> >> and creating a common driver that is easy to hook into.
> >>
> >> What has happened with that? My feeling is that we should stop adding
> >> more drivers like this in the platform code but rather put an
> >> authoritative copy into arch/arm/mm/ or even the top-level mm/ directory
> >> and change over the existing drivers to hook into that one.
> > no need anymore I send patch to add the support of phys/virt to genalloc so
> > now we just have to use it
> >
> > Best Regards,
> > J.
> >
> Exactly, and Russel already gave up on original patch. genpool is already a
> common driver.

Yeah but it seems that we can make arch/arm/mach-mmp/sram.c posted
in this thread a generic driver instead.

Regards,

Tony
