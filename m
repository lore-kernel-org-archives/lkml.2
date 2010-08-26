Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0HZM47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 08:56:59 -0400
Received: from sh.osrg.net ([192.16.179.4]:34257 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab0HZM45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 08:56:57 -0400
Date: Thu, 26 Aug 2010 21:56:45 +0900
To: fernando.lugo@ti.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, ohad@wizery.com, hiroshi.doyu@nokia.com,
        ameya.palande@nokia.com, felipe.contreras@nokia.com
Subject: RE: [PATCH 8/9] dspbridge: add map support for big buffers
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <496565EC904933469F292DDA3F1663E602F10ED4B1@dlee06.ent.ti.com>
References: <1277943660-4112-9-git-send-email-x0095840@ti.com>
	<20100826155416J.fujita.tomonori@lab.ntt.co.jp>
	<496565EC904933469F292DDA3F1663E602F10ED4B1@dlee06.ent.ti.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100826215554N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 26 Aug 2010 21:56:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 07:38:26 -0500
"Guzman Lugo, Fernando" <fernando.lugo@ti.com> wrote:

> >> due to a restriction in scatter gather lists, it can
> >> not be created a list for a buffer bigger than 1MB.
> >> This patch is spliting big mappings into 1MB mappings.
> >
> >I don't read the whole thread but the above description is incorrect.
> >
> >Why can't you use scatter gather chaining? You can create a scatter
> >list for a buffer larger than 1MB.
> 
> The thing is that ARM architecture does not support SG chaining. This patch should be
> seen like a workaround until it is fixed in iovmm module.

Fix iovmm module is easier than the workaround?

>From a quick look, arch/arm/plat-omap/iovmm.c does nothing wrong about
scatter gather chaining. arm/arm/mm/dma-mapping.c looks fine too about
it. Maybe just defining ARCH_HAS_SG_CHAIN works?
