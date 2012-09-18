Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab2IRHie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:38:34 -0400
Received: from linux-sh.org ([111.68.239.195]:33998 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082Ab2IRHic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:38:32 -0400
Date: Tue, 18 Sep 2012 16:37:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 19/24] sh: use __iomem pointers for MMIO
Message-ID: <20120918073741.GN13568@linux-sh.org>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
 <1347658492-11608-20-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347658492-11608-20-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 11:34:47PM +0200, Arnd Bergmann wrote:
> ARM is moving to stricter checks on readl/write functions,
> so we need to use the correct types everywhere.
> 
> I'm not completely sure about this patch, and it will
> probably require some arch/sh changes to go along with it,
> but it's clear that something has to be done to avoid
> getting hundreds of new warnings on each shmobile build
> in v3.7.
> Please see this as a prototype.
> 
I have no intention of making this change for arch/sh.

The __raw variants already accept both __iomem pointers and integer
addresses, which was largely intentional. New code could use the __iomem
annotations while older code could continue to use the integer addresses
without issue. If you wish to go through the kernel and audit every
single __raw user, you're certainly welcome to, but until then such a
change is premature.
