Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab0HZODW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 10:03:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:39849 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab0HZODT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 10:03:19 -0400
Date: Thu, 26 Aug 2010 23:03:01 +0900
To: fernando.lugo@ti.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, ohad@wizery.com, hiroshi.doyu@nokia.com,
        ameya.palande@nokia.com, felipe.contreras@nokia.com
Subject: RE: [PATCH 8/9] dspbridge: add map support for big buffers
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <496565EC904933469F292DDA3F1663E602F10ED4B3@dlee06.ent.ti.com>
References: <496565EC904933469F292DDA3F1663E602F10ED4B1@dlee06.ent.ti.com>
	<20100826215554N.fujita.tomonori@lab.ntt.co.jp>
	<496565EC904933469F292DDA3F1663E602F10ED4B3@dlee06.ent.ti.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100826230139Y.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 26 Aug 2010 23:03:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 08:16:24 -0500
"Guzman Lugo, Fernando" <fernando.lugo@ti.com> wrote:

> >From a quick look, arch/arm/plat-omap/iovmm.c does nothing wrong about
> >scatter gather chaining. arm/arm/mm/dma-mapping.c looks fine too about
> >it. Maybe just defining ARCH_HAS_SG_CHAIN works?
> 
> I can try, but it looks tricky for me. Maybe someone else can tell us why
> SG chain is not supported for ARM or if there is a problem just defining 
> ARCH_HAS_SG_CHAIN.

I suppose that nobody in ARM has been interested in the feature. It
was invented to improve I/O performance with large I/O requests. No
wonder embeded people aren't interested in it.

fujita@rose:~/git/linux-2.6$ find arch -name 'scatterlist.h'|xargs grep HAS_SG
arch/x86/include/asm/scatterlist.h:#define ARCH_HAS_SG_CHAIN
arch/ia64/include/asm/scatterlist.h:#define ARCH_HAS_SG_CHAIN
arch/sparc/include/asm/scatterlist.h:#define ARCH_HAS_SG_CHAIN
arch/powerpc/include/asm/scatterlist.h:#define ARCH_HAS_SG_CHAIN
