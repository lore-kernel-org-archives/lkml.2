Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab2CLVKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 17:10:07 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59668 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab2CLVKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 17:10:05 -0400
MIME-Version: 1.0
In-Reply-To: <1330000688-11226-1-git-send-email-thomas.abraham@linaro.org>
References: <1330000688-11226-1-git-send-email-thomas.abraham@linaro.org>
Date: Tue, 13 Mar 2012 02:40:03 +0530
Message-ID: <CAJuYYwQMB0ANS6noscRe6P4d0JKmTPLP_1r2Sr6-N3amAZiD5Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] regulator: add irq domain and device tree support
 for MAX8997
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: k.lewandowsk@samsung.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, broonie@opensource.wolfsonmicro.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob/Grant,

On 23 February 2012 18:08, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> Changes since v2:
> - Atleast one voltage level has to be specfied for Buck 1/2/5 even if GPIO
>  DVS option is not used (suggested by MyungJoo Ham).
> - Reworked the irq_domain support based the v5 of irq_domain generalization
>  patches.
>
> MAX8997 is a multi-function device which includes support for regulators, rtc,
> battery charger and other sub-blocks. This patchset adds device tree support
> for the pmic (regulators) sub-block.
>
> The first patch adds irq domain support for the interrupts supported by max8997
> mainly for removing the need to pass a irq_base from the platform code. The
> irq_base could not anyway be passed in case of device tree based instantiation.
> The reverse mapping method used is linear since the sub-drivers of max8997 has
> access to the max8997 irq_domain from which the linux irq number can be
> obtained.
>
> The second patch adds device tree support for max8997. This patch modifies both
> mfd and regulator portions of the max8997 code.
>
> This patchset is based on the following tree.
> http://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git [for-next]
>
> with all patches merged from
> http://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git [for-next]
> http://git.secretlab.ca/git/linux-2.6.git [irqdomain/next]
>
> and depends on the following patchset.
> [PATCH v3 0/4] ARM: Exynos4: Add irq domain and device tree support for wakeup interrupts.
>
> This patchset has been tested on Origen board.
>
> Thomas Abraham (2):
>  mfd: add irq domain support for max8997 interrupts
>  regulator: add device tree support for max8997

Any comments for this patch series?

Thanks,
Thomas.

>
>  .../devicetree/bindings/regulator/max8997-pmic.txt |  134 +++++++++++++++++++
>  arch/arm/mach-exynos/mach-nuri.c                   |    4 -
>  arch/arm/mach-exynos/mach-origen.c                 |    1 -
>  drivers/mfd/max8997-irq.c                          |   60 +++++----
>  drivers/mfd/max8997.c                              |   73 ++++++++++-
>  drivers/regulator/max8997.c                        |  139 +++++++++++++++++++-
>  include/linux/mfd/max8997-private.h                |    4 +-
>  include/linux/mfd/max8997.h                        |    2 +-
>  8 files changed, 382 insertions(+), 35 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/regulator/max8997-pmic.txt
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
