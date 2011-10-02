Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1JBSz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:55:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56265 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab1JBSzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:55:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/30] ARM: omap2/n8x0: work around modular omap mmc
Date: Sun, 02 Oct 2011 20:54:58 +0200
Message-ID: <1412062.DNcqS3fczZ@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20111002155331.GA12323@n2100.arm.linux.org.uk>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-12-git-send-email-arnd@arndb.de> <20111002155331.GA12323@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Nuk/pFBkJbrM7Mt/y+JpkuB8q+bTgZyGOQWt4C1JYTQ
 FLUemhw5Byc4dhiOMiAPRAa9JxxRKu80SaXQSxhaMVOiJXDCgy
 iAiY3dXPYuq+EGLkL5x2ilxSZl0OIeOG7d44Xfo3pccSJzf4bH
 GiGJkU/Ksh1aZD26PEImuQQoG7oxIf+4727gFkBKS3K/I+FQJ0
 xpLGzJTlFfmq1odJ0fBokFmKRl80LlR3fJDCs9V7Hpj3JZpZ1H
 CEEjBB1B62NHYNPD6calFiCmCoqR8R+xBlZGdsw9NT2mT8JyP1
 Dig+C2319Rb9t4P7P4jFqO/jRgBl8PMpAXneRYLMdPgHb2GKBI
 hcQazYe22iHKYCEqKLio=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 16:53:31 Russell King - ARM Linux wrote:
> On Sun, Oct 02, 2011 at 04:45:41PM +0200, Arnd Bergmann wrote:
> > -#if defined(CONFIG_MENELAUS) &&                                              \
> > -     (defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE))
> > +#if defined(CONFIG_MENELAUS) && defined(CONFIG_MMC_OMAP)
> > +/* || defined(CONFIG_MMC_OMAP_MODULE)) */
> > +/* FIXME: cannot call omap_mmc_notify_cover_event for ONFIG_MMC_OMAP_MODULE */
> 
> #ifdef CONFIG_MMC_OMAP_MODULE
> #warning FIXME: cannot call omap_mmc_notify_cover_event for CONFIG_MMC_OMAP_MODULE
> #endif
> #if defined(CONFIG_MENELAUS) && defined(CONFIG_MMC_OMAP)
> 
> So that it can be seen at build time?
> 
> Also note the 'ONFIG' typo...

Ok, good idea. I've updated the patch in the git tree accordingly.

Depending on what Tony wants, I might send out the entire series
again once there are no more new comments.

	Arnd
