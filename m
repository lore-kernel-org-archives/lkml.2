Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030882Ab2CGWns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:43:48 -0500
Received: from relais.videotron.ca ([24.201.245.36]:26739 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030205Ab2CGWnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:43:45 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 07 Mar 2012 17:43:43 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Michal Marek <mmarek@suse.cz>, linux-arch@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Mike Frysinger <vapier@gentoo.org>, linux-sh@vger.kernel.org,
        microblaze-uclinux@itee.uq.edu.au, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        uclinux-dist-devel@blackfin.uclinux.org, sparclinux@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH 2/3] Kbuild: Implement CONFIG_UIMAGE_KERNEL_NOLOAD
In-reply-to: <20120307213009.GF18787@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.02.1203071644180.24151@xanadu.home>
References: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org>
 <1331080238-1524-2-git-send-email-swarren@wwwdotorg.org>
 <20120307180815.GA27213@game.jcrosoft.org> <4F57AB92.6060907@wwwdotorg.org>
 <20120307183633.GB27213@game.jcrosoft.org> <4F57C4C6.2070602@wwwdotorg.org>
 <alpine.LFD.2.02.1203071537130.24151@xanadu.home>
 <20120307213009.GF18787@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Russell King - ARM Linux wrote:

> On Wed, Mar 07, 2012 at 04:03:04PM -0500, Nicolas Pitre wrote:
> > Well, I do have a patch series getting rid of ZRELADDR entirely, and 
> > AUTO_ZRELADDR would then become implicit, unless CONFIG_PHYS_OFFSET is 
> > defined.
> 
> Not possible, unless you're goign to also rip out uImage support.

I wish I could.  At least this new "noload" option would make uImage 
compatible with this.  That won't help existing u-Boot installations 
though, which is why I didn't post that patch series yet as I still 
haven't found a good fallback.

> Otherwise, how do we deal with platforms like Versatile Express where
> uboot does a funky relocation of data depending on whether the uImage
> it's loading is for the low 256MB RAM mapping or the high 1GB RAM
> mapping.

Doesn't it use AUTO_ZRELADDR?  With the newer u-Boot, you'd just load 
uImage to whatever address and u-Boot won't mess with it.


Nicolas
