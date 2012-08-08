Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370Ab2HHXIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 19:08:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47607 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2HHXIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 19:08:51 -0400
Date: Wed, 08 Aug 2012 16:08:50 -0700 (PDT)
Message-Id: <20120808.160850.2106318395245281875.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, sr@denx.de, peppe.cavallaro@st.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 07/11] net/stmmac: mark probe function as __devinit
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344437248-20560-8-git-send-email-arnd@arndb.de>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
	<1344437248-20560-8-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed,  8 Aug 2012 16:47:24 +0200

> Driver probe functions are generally __devinit so they will be
> discarded after initialization for non-hotplug kernels.
> This was found by a new warning after patch 6a228452d "stmmac: Add
> device-tree support" adds a new __devinit function that is called
> from stmmac_pltfr_probe.
> 
> Without this patch, building socfpga_defconfig results in:
> 
> WARNING: drivers/net/ethernet/stmicro/stmmac/stmmac.o(.text+0x5d4c): Section mismatch in reference from the function stmmac_pltfr_probe() to the function .devinit.text:stmmac_probe_config_dt()
> The function stmmac_pltfr_probe() references
> the function __devinit stmmac_probe_config_dt().
> This is often because stmmac_pltfr_probe lacks a __devinit
> annotation or the annotation of stmmac_probe_config_dt is wrong.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Stefan Roese <sr@denx.de>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org

Applied, thanks.
