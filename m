Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab2HWCJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:09:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33062 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab2HWCJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:09:49 -0400
Date: Thu, 23 Aug 2012 10:10:20 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 4/6] ARM: imx: fix ksz9021rn_phy_fixup
Message-ID: <20120823021017.GB24242@S2101-09.ap.freescale.net>
References: <1345648390-4234-1-git-send-email-arnd@arndb.de>
 <1345648390-4234-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345648390-4234-5-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 05:13:08PM +0200, Arnd Bergmann wrote:
> The ksz9021rn_phy_fixup and mx6q_sabrelite functions try to
> set up an ethernet phy if they can. They do check whether
> phylib is enabled, but unfortunately the functions can only
> be called from platform code if phylib is builtin, not
> if it is a module
> 
> Without this patch, building with a modular phylib results in:
> 
> arch/arm/mach-imx/mach-imx6q.c: In function 'imx6q_sabrelite_init':
> arch/arm/mach-imx/mach-imx6q.c:120:5: error: 'ksz9021rn_phy_fixup' undeclared (first use in this function)
> arch/arm/mach-imx/mach-imx6q.c:120:5: note: each undeclared identifier is reported only once for each function it appears in
> 
> The bug was originally reported by Artem Bityutskiy but only
> partially fixed in ef441806 "ARM: imx6q: register phy fixup only when
> CONFIG_PHYLIB is enabled".
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Artem Bityutskiy <dedekind1@gmail.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>

Acked-by: Shawn Guo <shawn.guo@linaro.org>
