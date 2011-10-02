Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1JBPxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 11:53:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48586 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab1JBPxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 11:53:45 -0400
Date: Sun, 2 Oct 2011 16:53:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/30] ARM: omap2/n8x0: work around modular omap mmc
Message-ID: <20111002155331.GA12323@n2100.arm.linux.org.uk>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-12-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317566760-25681-12-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 04:45:41PM +0200, Arnd Bergmann wrote:
> -#if defined(CONFIG_MENELAUS) &&						\
> -	(defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE))
> +#if defined(CONFIG_MENELAUS) && defined(CONFIG_MMC_OMAP)
> +/* || defined(CONFIG_MMC_OMAP_MODULE)) */
> +/* FIXME: cannot call omap_mmc_notify_cover_event for ONFIG_MMC_OMAP_MODULE */

#ifdef CONFIG_MMC_OMAP_MODULE
#warning FIXME: cannot call omap_mmc_notify_cover_event for CONFIG_MMC_OMAP_MODULE
#endif
#if defined(CONFIG_MENELAUS) && defined(CONFIG_MMC_OMAP)

So that it can be seen at build time?

Also note the 'ONFIG' typo...
