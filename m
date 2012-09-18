Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab2IRHLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:11:35 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:56218 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609Ab2IRHLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:11:34 -0400
Date: Tue, 18 Sep 2012 16:11:31 +0900
From: Simon Horman <horms@verge.net.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Magnus Damm <magnus.damm@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 01/24] ARM: shmobile: use __iomem pointers for MMIO
Message-ID: <20120918071131.GB31953@verge.net.au>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
 <1347658492-11608-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347658492-11608-2-git-send-email-arnd@arndb.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 11:34:29PM +0200, Arnd Bergmann wrote:
> ARM is moving to stricter checks on readl/write functions,
> so we need to use the correct types everywhere.
> 
> This patch is a bit ugly for shmobile, which is the only platform
> that just uses integer literals all over the place, but I can't
> see a better way to do this.
> 
> Cc: Magnus Damm <magnus.damm@gmail.com>
> Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: linux-sh@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Wow, thats a lot of chrun, but if we must

Acked-by: Simon Horman <horms@verge.net.au>

> ---
>  arch/arm/mach-shmobile/board-ap4evb.c          |   12 ++--
>  arch/arm/mach-shmobile/board-armadillo800eva.c |    6 +-
>  arch/arm/mach-shmobile/board-bonito.c          |    8 +--
>  arch/arm/mach-shmobile/board-g3evm.c           |   12 ++--
>  arch/arm/mach-shmobile/board-g4evm.c           |   30 +++++-----
>  arch/arm/mach-shmobile/board-kzm9g.c           |    8 +--
>  arch/arm/mach-shmobile/board-mackerel.c        |   22 ++++----
>  arch/arm/mach-shmobile/clock-r8a7740.c         |   46 ++++++++--------
>  arch/arm/mach-shmobile/clock-sh7367.c          |   44 +++++++--------
>  arch/arm/mach-shmobile/clock-sh7372.c          |   60 ++++++++++----------
>  arch/arm/mach-shmobile/clock-sh7377.c          |   50 ++++++++---------
>  arch/arm/mach-shmobile/clock-sh73a0.c          |   70 ++++++++++++------------
>  arch/arm/mach-shmobile/include/mach/gpio.h     |    6 +-
>  arch/arm/mach-shmobile/intc-r8a7779.c          |   14 ++---
>  arch/arm/mach-shmobile/intc-sh7372.c           |   27 +++++----
>  arch/arm/mach-shmobile/intc-sh73a0.c           |   20 ++++---
>  arch/arm/mach-shmobile/pm-rmobile.c            |    6 +-
>  arch/arm/mach-shmobile/pm-sh7372.c             |   57 +++++++++----------
>  arch/arm/mach-shmobile/setup-sh7367.c          |    2 +-
>  arch/arm/mach-shmobile/setup-sh7377.c          |    2 +-
>  arch/arm/mach-shmobile/setup-sh73a0.c          |    2 +-
>  include/linux/serial_sci.h                     |    2 +-
>  22 files changed, 256 insertions(+), 250 deletions(-)
