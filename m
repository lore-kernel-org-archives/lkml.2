Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab2HHPHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:07:33 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:10444 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab2HHPHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:07:32 -0400
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGoheedClaTaNdBkW0QOb9J0FJuBIaIwpbJMlw==
X-RZG-CLASS-ID: mo05
Message-ID: <502280A9.5070009@denx.de>
Date: Wed, 08 Aug 2012 17:07:21 +0200
From: Stefan Roese <sr@denx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 07/11] net/stmmac: mark probe function as __devinit
References: <1344437248-20560-1-git-send-email-arnd@arndb.de> <1344437248-20560-8-git-send-email-arnd@arndb.de>
In-Reply-To: <1344437248-20560-8-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 04:47 PM, Arnd Bergmann wrote:
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

Acked-by: Stefan Roese <sr@denx.de>

Thanks,
Stefan
