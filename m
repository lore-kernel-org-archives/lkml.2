Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab2GSS7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:59:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41896 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab2GSS7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:59:10 -0400
MIME-Version: 1.0
In-Reply-To: <5008279B.4000001@samsung.com>
References: <1342097668-25243-1-git-send-email-thomas.abraham@linaro.org>
	<5008279B.4000001@samsung.com>
Date: Fri, 20 Jul 2012 00:29:08 +0530
Message-ID: <CAJuYYwQBgpJ1wiS3fSDS2cMi6kanuO47rc8SmniAqjRPuBGJHg@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] mmc: dw_mmc: add support for device tree based instantiation
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 July 2012 20:58, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> Hi Thomas,
>
> I think not good that added the samsung specific code into dw_mmc-pltfm.c
> How about separating to dw-mmc-exynos.c?

I am not sure of this. The only samsung specific code in
dw_mmc-pltfm.c file is the data for of_device_id instances. The clock
lookup added into this file in the 3rd patch does not cause any harm
on non-samsung SoC's which might not define those clocks (on clock
lookup failure, there are only warning printed, the driver's probe
does not fail.

I would prefer not to add separate file for Exynos SoC's for now.
Splitting into different files will need to defined new callbacks
which I fell is not really required.

Thanks,
Thomas.

>
> Best Regards,
> Jaehoon Chung
>
> On 07/12/2012 09:54 PM, Thomas Abraham wrote:
>> This patch series adds device tree support for Synopsis Designware Mobile
>> Storage Host Controller.
>>
>> The first patch converts the copy of controller device instance into a
>> reference. This is need to allow device resource management api to correctly
>> manage the resources allocated by the driver. The second patch fixes the
>> incorrect abort of the probe in case a slot initialization fails. This is
>> fixed by allowing as many slots to be initialized successfully and failing
>> only if there are no slots that were initialized.
>>
>> The third patch adds clock lookup in the driver and this is optional. Platforms
>> that do not need any clock gating and control for the dw_mmc controllers will
>> not be affected with this change. The fourth patch adds a quirk to notify the
>> controller about the absence of the write protect line.
>>
>> The fifth patch adds device tree based discovery support for the dw_mmc driver.
>> The sixth patch add Samsung Exynos5250 specific extentions to the driver.
>>
>> This patchset is based on Samsung kernel tree's for-next branch with the
>> mmc tree's mmc-next branch merged.
>>
>> Thomas Abraham (6):
>>   mmc: dw_mmc: convert copy of struct device in struct dw_mci to a reference
>>   mmc: dw_mmc: allow probe to succeed even if one slot is initialized
>>   mmc: dw_mmc: lookup for optional biu and ciu clocks
>>   mmc: dw_mmc: add quirk to indicate missing write protect line
>>   mmc: dw_mmc: add device tree support
>>   mmc: dw_mmc: add samsung exynos5250 specific extentions
>>
>>  .../devicetree/bindings/mmc/synposis-dw-mshc.txt   |  144 ++++++++
>>  drivers/mmc/host/dw_mmc-pci.c                      |    2 +-
>>  drivers/mmc/host/dw_mmc-pltfm.c                    |   41 +++-
>>  drivers/mmc/host/dw_mmc.c                          |  364 +++++++++++++++++---
>>  drivers/mmc/host/dw_mmc.h                          |   23 ++
>>  include/linux/mmc/dw_mmc.h                         |   17 +-
>>  6 files changed, 538 insertions(+), 53 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/mmc/synposis-dw-mshc.txt
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
