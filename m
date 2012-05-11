Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422668Ab2EKSJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:09:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21676 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422636Ab2EKSJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:09:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6708"; a="190113390"
Date: Fri, 11 May 2012 11:09:26 -0700
From: David Brown <davidb@codeaurora.org>
To: Olof Johansson <olof@lixom.net>
Cc: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] arm: msm: fix up very basic HTC Sapphire support
Message-ID: <20120511180926.GC12227@codeaurora.org>
References: <1334203443-30011-1-git-send-email-dwalker@fifo99.com>
 <CAOesGMiHfQwWXSQwvcEPxY63FEjbsB7ux4dHvAPM99Kf43cDZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOesGMiHfQwWXSQwvcEPxY63FEjbsB7ux4dHvAPM99Kf43cDZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 01:39:05AM -0700, Olof Johansson wrote:
> Hi,
> 
> On Wed, Apr 11, 2012 at 9:04 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> > Adds sapphire into the make file, and fixes all the code problems that
> > prevented it from building (including adding board-sapphire.h)
> >
> > Signed-off-by: Daniel Walker <dwalker@fifo99.com>
> > ---
> >  arch/arm/mach-msm/Kconfig          |   10 +-
> >  arch/arm/mach-msm/Makefile         |    1 +
> >  arch/arm/mach-msm/board-sapphire.c |   18 +--
> >  arch/arm/mach-msm/board-sapphire.h |  224 ++++++++++++++++++++++++++++++++++++
> >  4 files changed, 235 insertions(+), 18 deletions(-)
> >  create mode 100644 arch/arm/mach-msm/board-sapphire.h
> >
> > diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> > index 1cd40ad..04f3b8e 100644
> > --- a/arch/arm/mach-msm/Kconfig
> > +++ b/arch/arm/mach-msm/Kconfig
> > @@ -6,7 +6,6 @@ choice
> >
> >  config ARCH_MSM7X00A
> >        bool "MSM7x00A / MSM7x01A"
> > -       select MACH_TROUT if !MACH_HALIBUT
> >        select ARCH_MSM_ARM11
> >        select MSM_SMD
> >        select MSM_SMD_PKG3
> > @@ -80,6 +79,7 @@ config  MSM_VIC
> >  menu "Qualcomm MSM Board Type"
> >
> >  config MACH_HALIBUT
> > +       select MACH_TROUT if !MACH_SAPPHIRE && !MACH_HALIBUT
> 
> This doesn't seem to make much sense here.
> 
> >        depends on ARCH_MSM
> >        depends on ARCH_MSM7X00A
> >        bool "Halibut Board (QCT SURF7201A)"
> > @@ -93,6 +93,14 @@ config MACH_TROUT
> >        help
> >          Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
> >
> > +config MACH_SAPPHIRE
> > +       select MACH_TROUT if !MACH_HALIBUT && !MACH_SAPPHIRE
> 
> Nor does this.
> 
> I presume these are here to make sure that at least one of the boards
> is selected. There are already build checks to make sure that at least
> one machine entry exists, so if a user mis-configures his kernel he
> will hit a build error. Seems as reasonable as any catch for this.
> 
> If you feel strongly that you need to select at least one board, then
> do so at the ARCH_ level, not on every board option.

I'll go ahead and leave this patch out of the msm-core tree for 3.5.
Daniel, feel free to update the patch, and I can make another pull.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
