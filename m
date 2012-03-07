Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965121Ab2CGSu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:50:26 -0500
Received: from relais.videotron.ca ([24.201.245.36]:52685 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759591Ab2CGSuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:50:23 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 07 Mar 2012 13:50:22 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Michal Marek <mmarek@suse.cz>,
        linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Mike Frysinger <vapier@gentoo.org>,
        linux-sh@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        uclinux-dist-devel@blackfin.uclinux.org, sparclinux@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH 2/3] Kbuild: Implement CONFIG_UIMAGE_KERNEL_NOLOAD
In-reply-to: <20120307180815.GA27213@game.jcrosoft.org>
Message-id: <alpine.LFD.2.02.1203071336210.24151@xanadu.home>
References: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org>
 <1331080238-1524-2-git-send-email-swarren@wwwdotorg.org>
 <20120307180815.GA27213@game.jcrosoft.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:

> On 17:30 Tue 06 Mar     , Stephen Warren wrote:
> > This allows the user to use U-Boot's mkimage's -T kernel_noload option
> > if their arch Kconfig allows it, and they desire.
> > 
> > Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> > ---
> > The next patch enables this new CONFIG_ALLOW_ option for ARM. I assume
> > that some other architectures will also be able to enable it, but I'm
> > not familiar enough with any to know which.
> I'm going to repeat. I don't think any impromevent here.

You know what?  I agree with you... on a conceptual level only though.

In reality, some people are are just too used to it, either for 
emotional reasons or simply because that's what was there before so they 
simply perpetuated it without thinking further, or whatever.  REmoving 
that support would just upset a lot of people.  And frankly we have 
better things to do than starting a flamewar over this.

So the next best thing is to make this u-Boot stuff well contained in a 
common place and make sure it doesn't spread incoherently over multiple 
architecture's directories and makefiles.  This way the u-Boot cruft 
won't be the ARM maintainer, or the PPC maintainer, or the SPARC 
maintainer, or any other architecture maintainer's business, but the 
responsibility of those who do care about it without affecting anyone 
else.

> And the uImage format here is called the legacy format where now U-Boot
> support a new format based on DT format.
> 
> Will you plan to add it too?

Why not if someone cares?  At least this will be done only 
once, centrally, without having to involve architecture maintainers.


Nicolas
