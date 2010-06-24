Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0FXKNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 06:13:32 -0400
Received: from smtp.nokia.com ([192.100.122.230]:52848 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab0FXKNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 06:13:30 -0400
Date: Thu, 24 Jun 2010 13:18:05 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Catalin Marinas <catalin.marinas@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Russell King <rmk@arm.linux.org.uk>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20100624101805.GM17639@pcarmody-desktop>
References: <20100624021949.62910287.sfr@canb.auug.org.au> <20100624103619.46a88a63.sfr@canb.auug.org.au> <1277370056.30452.9.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277370056.30452.9.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 24 Jun 2010 10:13:00.0226 (UTC) FILETIME=[D3079A20:01CB1385]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/10 11:00 +0200, ext Catalin Marinas wrote:
> On Thu, 2010-06-24 at 10:36 +1000, Stephen Rothwell wrote:
> > Hi Russell,
> > 
> > On Thu, 24 Jun 2010 02:19:49 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > After merging the final tree, the next-20100616 and later linux-next
> > > builds for most arm configs (including versatile_defconfig) failed like this:
> > > 
> > > In file included from include/linux/module.h:23,
> > >                  from include/linux/device.h:23,
> > >                  from include/linux/dma-mapping.h:4,
> > >                  from arch/arm/kernel/asm-offsets.c:15:
> > > include/trace/events/module.h:11: error: two or more data types in declaration 
> > > 
> > > Reverting commit f0028612a8ffedcdafa8b7ae83ab090d8b0318b4 ("ARM: 6171/1:
> > > module - simplify unwind table handling") (and
> > > cecaa4c6b8173b02c9f7ecfdbbc81f573a7a9f33 ("ARM: 6172/1: module -
> > > additional unwind tables for exit/devexit sections") that depends on it)
> > > fixes this build error.
> > 
> > I have reverted those 2 commits in linux-next today.
> 
> Thanks. Stephen, do you build with just the standard defconfig for
> ARCH=arm?
> 
> The problem is commit f0028612a8f which contains the hunk below for
> the !ARM_UNWIND case):
> 
> +struct mod_arch_specific {
> +}
> 
> Phil, could you please add a semicolon after '}' and send Russell a
> patch?

Such a patch has already been sent by Peter Huewe, last week:
http://lkml.org/lkml/2010/6/17/73


Phil
