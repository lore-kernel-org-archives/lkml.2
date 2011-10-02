Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1JBQDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 12:03:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53346 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1JBQDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 12:03:42 -0400
Date: Sun, 2 Oct 2011 17:03:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Miao <eric.y.miao@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: Re: [PATCH 16/26] ARM: pxa: CPU_PJ4 requires IWMMXT
Message-ID: <20111002160328.GZ11710@n2100.arm.linux.org.uk>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-17-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317499438-14058-17-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 10:03:48PM +0200, Arnd Bergmann wrote:
> The PJ4 based pxa95x cpus all have iwmmxt and there is no way to
> build that code conditionally, so better not ask the user
> in that configuration, in order to prevent broken builds.

This suggests we want IWMMXT=y if PJ4=y...

>  config IWMMXT
> -	bool "Enable iWMMXt support"
> +	bool "Enable iWMMXt support" if !CPU_PJ4
>  	depends on CPU_XSCALE || CPU_XSC3 || CPU_MOHAWK || CPU_PJ4
>  	default y if PXA27x || PXA3xx || PXA95x || ARCH_MMP
>  	help

This hides the option if CPU_PJ4 is enabled, but it will only be set
to 'y' if PXA27x || PXA3xx || PXA95x || ARCH_MMP are set.  Luckily,
ARCH_MMP will be - but is that really what's intended?  It's a little
obscure to work that out.
