Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1HRIAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:00:19 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:50038 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264Ab1HRIAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:00:15 -0400
X-Greylist: delayed 3458 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Aug 2011 04:00:15 EDT
Subject: Re: [PATCH 03/11] arch/unicore32: do not use EXTRA_AFLAGS or
 EXTRA_CFLAGS
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <CACqU3MWTEFy+XV7WH=FEP2hTvBu8VCgcYj-HCcVnSjKxZBQeeA@mail.gmail.com>
References: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
	 <1313384834-24433-4-git-send-email-lacombar@gmail.com>
	 <CACqU3MWTEFy+XV7WH=FEP2hTvBu8VCgcYj-HCcVnSjKxZBQeeA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Thu, 18 Aug 2011 16:00:57 +0800
Message-ID: <1313654457.2905.10.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks good for me.

Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Do I need to push the patch into unicore32 repo?

Thanks & Regards

Guan Xuetao


On Mon, 2011-08-15 at 01:13 -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Mon, Aug 15, 2011 at 1:07 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> > Usage of these flags has been deprecated for nearly 4 years by:
> >
> >    commit f77bf01425b11947eeb3b5b54685212c302741b8
> >    Author: Sam Ravnborg <sam@neptun.(none)>
> >    Date:   Mon Oct 15 22:25:06 2007 +0200
> >
> >        kbuild: introduce ccflags-y, asflags-y and ldflags-y
> >
> > Moreover, these flags (at least EXTRA_CFLAGS) have been documented for command
> > line use. By default, gmake(1) do not override command line setting, so this is
> > likely to result in build failure or unexpected behavior.
> >
> > Replace their usage by Kbuild's `{as,cc,ld}flags-y'.
> >
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> 
>  - Arnaud
> > ---
> >  arch/unicore32/boot/compressed/Makefile |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/unicore32/boot/compressed/Makefile b/arch/unicore32/boot/compressed/Makefile
> > index b0954a2..950a9af 100644
> > --- a/arch/unicore32/boot/compressed/Makefile
> > +++ b/arch/unicore32/boot/compressed/Makefile
> > @@ -10,8 +10,8 @@
> >  # Copyright (C) 2001~2010 GUAN Xue-tao
> >  #
> >
> > -EXTRA_CFLAGS   := -fpic -fno-builtin
> > -EXTRA_AFLAGS   := -Wa,-march=all
> > +ccflags-y      := -fpic -fno-builtin
> > +asflags-y      := -Wa,-march=all
> >
> >  OBJS           := misc.o
> >
> > --
> > 1.7.6.153.g78432
> >
> >


