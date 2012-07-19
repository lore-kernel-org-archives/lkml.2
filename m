Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2GSP2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 11:28:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36339 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2GSP2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 11:28:33 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-90-5008279fb872
Message-id: <5008279B.4000001@samsung.com>
Date: Fri, 20 Jul 2012 00:28:27 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615
 Thunderbird/13.0.1
MIME-version: 1.0
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: Re: [PATCH v3 0/6] mmc: dw_mmc: add support for device tree based
 instantiation
References: <1342097668-25243-1-git-send-email-thomas.abraham@linaro.org>
In-reply-to: <1342097668-25243-1-git-send-email-thomas.abraham@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jQd356hwBBotm6lpc3jWHzeLI/35G
	ixnn9zE5MHt83iQXwBjFZZOSmpNZllqkb5fAlbHo5WnmgsfCFf+vrWFrYJzN38XIySEhYCLx
	Zu5iNghbTOLCvfVgtpDAdEaJD/cjuxi5gOyXjBKHZr1hBknwCmhJTLo8mwXEZhFQlTiw7xUT
	iM0moCOx/dtxMFtUIEzi1d2fbBD1ghI/Jt8DqxcR0JM4+PQjK8hQZoF5TBKnn29gBUkIC0RJ
	zO7uASriANrmKfHqjwNImFPAS+L6yhawEmag+ftbp7FB2PISm9e8ZZ7AKDALyYpZSMpmISlb
	wMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4KJ9J7WBc2WBxiFGAg1GJh1dTjT1AiDWx
	rLgy9xCjBAezkgjvIjWOACHelMTKqtSi/Pii0pzU4kOM0hwsSuK8xt5f/YUE0hNLUrNTUwtS
	i2CyTBycUg2MaV9PC/68Jdgl6Hx4YtdnsW1Bv+89nszpwr3IIP7bW/bzWlXP3wUXxtRFXFq7
	kOsfa+6DdeJsd/9cmfnnW3nw+dAdTh8+X1sVs7m+c/XNlozFF9d+FL0/abvNib8lT9sU/2zJ
	e7ElWOZFiHYUY42/gUys6UTppFO34jKuVLCvZs8u5Zz16VmKsxJLcUaioRZzUXEiAK+G/0dG	AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I think not good that added the samsung specific code into dw_mmc-pltfm.c
How about separating to dw-mmc-exynos.c?

Best Regards,
Jaehoon Chung

On 07/12/2012 09:54 PM, Thomas Abraham wrote:
> This patch series adds device tree support for Synopsis Designware Mobile
> Storage Host Controller.
> 
> The first patch converts the copy of controller device instance into a
> reference. This is need to allow device resource management api to correctly
> manage the resources allocated by the driver. The second patch fixes the
> incorrect abort of the probe in case a slot initialization fails. This is
> fixed by allowing as many slots to be initialized successfully and failing
> only if there are no slots that were initialized.
> 
> The third patch adds clock lookup in the driver and this is optional. Platforms
> that do not need any clock gating and control for the dw_mmc controllers will
> not be affected with this change. The fourth patch adds a quirk to notify the
> controller about the absence of the write protect line.
> 
> The fifth patch adds device tree based discovery support for the dw_mmc driver.
> The sixth patch add Samsung Exynos5250 specific extentions to the driver.
> 
> This patchset is based on Samsung kernel tree's for-next branch with the
> mmc tree's mmc-next branch merged.
> 
> Thomas Abraham (6):
>   mmc: dw_mmc: convert copy of struct device in struct dw_mci to a reference
>   mmc: dw_mmc: allow probe to succeed even if one slot is initialized
>   mmc: dw_mmc: lookup for optional biu and ciu clocks
>   mmc: dw_mmc: add quirk to indicate missing write protect line
>   mmc: dw_mmc: add device tree support
>   mmc: dw_mmc: add samsung exynos5250 specific extentions
> 
>  .../devicetree/bindings/mmc/synposis-dw-mshc.txt   |  144 ++++++++
>  drivers/mmc/host/dw_mmc-pci.c                      |    2 +-
>  drivers/mmc/host/dw_mmc-pltfm.c                    |   41 +++-
>  drivers/mmc/host/dw_mmc.c                          |  364 +++++++++++++++++---
>  drivers/mmc/host/dw_mmc.h                          |   23 ++
>  include/linux/mmc/dw_mmc.h                         |   17 +-
>  6 files changed, 538 insertions(+), 53 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


