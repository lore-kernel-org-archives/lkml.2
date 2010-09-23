Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab0IWRuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:50:13 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:46729 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755896Ab0IWRuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:50:11 -0400
Date: Thu, 23 Sep 2010 10:49:18 -0700
From: matt mooney <mfm@muteddisk.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kernel-janitors@vger.kernel.org, Alexander Graf <agraf@suse.de>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Avi Kivity <avi@redhat.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 12/20] powerpc: change to new flag variables
Message-ID: <20100923174918.GA3035@haskell.muteddisk.com>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	kernel-janitors@vger.kernel.org, Alexander Graf <agraf@suse.de>,
	linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
	Avi Kivity <avi@redhat.com>, linuxppc-dev@lists.ozlabs.org
References: <1285224669-29865-1-git-send-email-mfm@muteddisk.com>
 <20100923201923.366779a1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923201923.366779a1.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:19 Thu 23 Sep     , Stephen Rothwell wrote:
> Hi Matt,
> 
> On Wed, 22 Sep 2010 23:51:09 -0700 matt mooney <mfm@muteddisk.com> wrote:
> >
> > Replace EXTRA_CFLAGS with ccflags-y and EXTRA_AFLAGS with asflags-y.
> 
> This looks good.  One comment below ...
> 
> > --- a/arch/powerpc/platforms/pseries/Makefile
> > +++ b/arch/powerpc/platforms/pseries/Makefile
> > @@ -1,10 +1,5 @@
> > -ifeq ($(CONFIG_PPC64),y)
> > -EXTRA_CFLAGS		+= -mno-minimal-toc
> > -endif
> > -
> > -ifeq ($(CONFIG_PPC_PSERIES_DEBUG),y)
> > -EXTRA_CFLAGS		+= -DDEBUG
> > -endif
> > +ccflags-$(CONFIG_PPC64)			:= -mno-minimal-toc
> > +ccflags-$(CONFIG_PPC_PSERIES_DEBUG)	+= -DDEBUG
> >  
> >  obj-y			:= lpar.o hvCall.o nvram.o reconfig.o \
> >  			   setup.o iommu.o event_sources.o ras.o \
> > @@ -23,7 +18,7 @@ obj-$(CONFIG_MEMORY_HOTPLUG)	+= hotplug-memory.o
> >  obj-$(CONFIG_HVC_CONSOLE)	+= hvconsole.o
> >  obj-$(CONFIG_HVCS)		+= hvcserver.o
> >  obj-$(CONFIG_HCALL_STATS)	+= hvCall_inst.o
> > -obj-$(CONFIG_PHYP_DUMP)	+= phyp_dump.o
> > +obj-$(CONFIG_PHYP_DUMP)		+= phyp_dump.o
> >  obj-$(CONFIG_CMM)		+= cmm.o
> >  obj-$(CONFIG_DTL)		+= dtl.o
> 
> This looks like a spurious extra hunk.

Hi Stephen,

Yeah your right, logically it doesn't follow from my changeset. I should
have left it alone, but it was the only line in the file that didn't align
properly with its surrounding area.

-mfm

