Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab2IEFyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:54:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63984 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab2IEFyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:54:09 -0400
Date: Wed, 5 Sep 2012 13:54:12 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <b29396@freescale.com>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de,
        kernel@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, richard.zhao@freescale.com,
        devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org
Subject: Re: [PATCH v6 0/4] add syscon driver based on regmap for general
 registers access
Message-ID: <20120905055410.GZ2362@S2101-09.ap.freescale.net>
References: <1346813836-28736-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346813836-28736-1-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

The series needs to go via mfd or arm-soc tree as a whole.  In case
you want to take it through mfd tree, here is my ack.

Acked-by: Shawn Guo <shawn.guo@linaro.org>

Otherwise, I can take it via arm-soc tree with your ack.

Regards,
Shawn

On Wed, Sep 05, 2012 at 10:57:12AM +0800, Dong Aisheng wrote:
> This patch series mainly adds an syscon driver which is used to access
> general system controller registers like FSL IOMUXC GPR and ANATOP,
> after that, we convert all the exist private access general registers code to use
> standard API from regmap to access registers.
> Finally we remove the old mfd anatop driver which is only for anatop register
> access.
> 
> The patch series is based on linus's tree 3.6-rc4 since commit 5b716ac.
> 
> ChangeLog v5->v6:
>  * put node after call syscon_node_to_regmap in anatop regulator driver
>  * using dev instead of &pdev->dev in syscon probe
> ChangeLog v4->v5:
>  * change syscon driver depends on OF
>  * do not call of_node_put in syscon_node_to_regmap
>  * renamed: include/linux/fsl/imx6q-iomuxc-gpr.h ->
> 	    include/linux/mfd/syscon/imx6q-iomuxc-gpr.h
> ChangeLog v3->v4:
> Only '[PATCH v4 1/7] mfd: add syscon driver based on regmap' is changed.
> 
> Dong Aisheng (4):
>   mfd: add syscon driver based on regmap
>   ARM: imx6q: add iomuxc gpr support into syscon
>   regulator: anatop-regulator: convert to use syscon to access anatop
>     register
>   mfd: anatop-mfd: remove anatop driver
> 
>  Documentation/devicetree/bindings/mfd/syscon.txt |   20 ++
>  arch/arm/boot/dts/imx6q.dtsi                     |    9 +-
>  arch/arm/mach-imx/Kconfig                        |    2 +-
>  arch/arm/mach-imx/mach-imx6q.c                   |   47 ++--
>  drivers/mfd/Kconfig                              |   12 +-
>  drivers/mfd/Makefile                             |    2 +-
>  drivers/mfd/anatop-mfd.c                         |  124 ---------
>  drivers/mfd/syscon.c                             |  176 ++++++++++++
>  drivers/regulator/Kconfig                        |    2 +-
>  drivers/regulator/anatop-regulator.c             |   31 ++-
>  include/linux/mfd/anatop.h                       |   40 ---
>  include/linux/mfd/syscon.h                       |   23 ++
>  include/linux/mfd/syscon/imx6q-iomuxc-gpr.h      |  319 ++++++++++++++++++++++
>  13 files changed, 593 insertions(+), 214 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/syscon.txt
>  delete mode 100644 drivers/mfd/anatop-mfd.c
>  create mode 100644 drivers/mfd/syscon.c
>  delete mode 100644 include/linux/mfd/anatop.h
>  create mode 100644 include/linux/mfd/syscon.h
>  create mode 100644 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h
> 
> 
