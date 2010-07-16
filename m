Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966068Ab0GPSTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:19:35 -0400
Received: from relais.videotron.ca ([24.201.245.36]:41243 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966021Ab0GPSTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:19:33 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_Wf+0RgYv1FmLbMIJACq6tA)"
Date: Fri, 16 Jul 2010 14:19:31 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for
 defconfig
In-reply-to: <AANLkTinyFBTKYaryFANYheTuP-biJUws2x01NRNZPb4M@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1007161406120.10598@xanadu.home>
References: <20100713230352.6781.18644.stgit@angua>
 <1279296221.17878.66.camel@e102109-lin.cambridge.arm.com>
 <AANLkTinyFBTKYaryFANYheTuP-biJUws2x01NRNZPb4M@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_Wf+0RgYv1FmLbMIJACq6tA)
Content-type: TEXT/PLAIN; charset=ISO-8859-1
Content-transfer-encoding: 8BIT

On Fri, 16 Jul 2010, Grant Likely wrote:

> On Fri, Jul 16, 2010 at 10:03 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On Wed, 2010-07-14 at 00:04 +0100, Grant Likely wrote:
> >> - It still doesn't resolve dependencies.  A solver would help with this.
> >>   For the time being I work around the problem by running the generated
> >>   config through 'oldconfig' and looking for differences.  If the files
> >>   differ (ignoring comments and generateconfig_* options) after oldconfig,
> >>   then the <board>_defconfig target returns a failure.  (but leaves the
> >>   new .config intact so the user can resolve it with menuconfig).  This
> >>   way at least the user is told when a Kconfig fragment is invalid.
> >
> > It's not a solver but I'm pushing a patch to warn on selecting symbols
> > with unmet dependencies so that you can select further symbols (manual
> > solving). The patch is in linux-next but you also can grab it from:
> >
> > http://git.kernel.org/?p=linux/kernel/git/cmarinas/linux-2.6-cm.git;a=commitdiff_plain;h=5d87db2d2a332784bbf2b1ec3e141486f4d41d6f
> 
> sfr and I were talking about your patch the other day.  Just warning
> on incomplete dependencies is enough to make it actually workable for
> me (without my ugly post-processing step).  I was very happy to hear
> that it is in linux-next.
> 
> Last missing piece is being able to do "select FOO = n", which Stephen
> is currently working on.

Instead of (or in addition to) warning for incomplete 
dependencies, I'd much prefer if the prerequisites were recursively 
selected automatically.  This way if some options are moved inside a 
submenu at some point with a config symbol for that subcategory 
(e.g. CONFIG_NETDEV_1000), or if the subsystem is reorganized into 
submodules that are required for some driver to work, then my 
config will still be fine.

For example, if I want CONFIG_MTD_CMDLINE_PARTS=y, the system may be 
smart enough to notice and automatically enable CONFIG_MTD and 
CONFIG_MTD_PARTITIONS without having to carry those in the defconfig.


Nicolas

--Boundary_(ID_Wf+0RgYv1FmLbMIJACq6tA)--
