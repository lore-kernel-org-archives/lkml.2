Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194Ab2EJKzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:55:20 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48988 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759118Ab2EJKzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:55:15 -0400
MIME-Version: 1.0
In-Reply-To: <4FA0E706.8060700@samsung.com>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
	<1335935266-25289-5-git-send-email-thomas.abraham@linaro.org>
	<CAH9JG2XBinh=XAVnt3EnWrEqeTKz34d9yB6wfiuF-J-Se_Q__Q@mail.gmail.com>
	<4FA0E706.8060700@samsung.com>
Date: Thu, 10 May 2012 16:25:15 +0530
Message-ID: <CAJuYYwS=qExrAjG1kgd=tPYL0pQeP+7xE1SuMaP+do-Eg3D7eQ@mail.gmail.com>
Subject: Re: [PATCH 4/7] mmc: dw_mmc: add samsung exynos5250 specific extentions
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Kyungmin Park <kmpark@infradead.org>, linux-mmc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2012 13:19, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> On 05/02/2012 04:01 PM, Kyungmin Park wrote:
>
>> Hi,
>>
>> On 5/2/12, Thomas Abraham <thomas.abraham@linaro.org> wrote:
>>> The instantiation of the Synopsis Designware controller on Exynos5250
>>> include extension for SDR and DDR specific tx/rx phase shift timing
>>> and CIU internal divider. In addition to that, the option to skip the
>>> command hold stage is also introduced. Add support for these Exynos5250
>>> specfic extenstions.

[...]

>>> @@ -265,6 +266,10 @@ static u32 dw_mci_prepare_command(struct mmc_host *mmc,
>>> struct mmc_command *cmd)
>>>                      cmdr |= SDMMC_CMD_DAT_WR;
>>>      }
>>>
>>> +    if (slot->host->drv_data->ctrl_type == DW_MCI_TYPE_EXYNOS5250)
>>> +            if (SDMMC_CLKSEL_GET_SELCLK_DRV(mci_readl(slot->host, CLKSEL)))
>>> +                    cmdr |= SDMMC_USE_HOLD_REG;
>> Some other board, custom SOC also can use this HOLD register. So it's
>> not EXYNOS5250 specific one. I think we introduce the more generic
>> quirks for this instead of SOC specific.
>
> One more, I think that also need to check the IMPLEMENT_HOLD_REG bit in HCON register.
> It has dependency with that.

The above code is specific to Exynos5250 and hence it is not required
to check the IMPLEMENT_HOLD_REG bit in HCON register. On Exynos5250,
the hold register is implemented and available.


> As Mr.Park is mentioned, this register is clock phasing.
> In spec, card is enumerated in SDR12 or SDR25 mode, the application must program the use_hold_reg.

Exynos5250 hardware manual specifies additional restrictions on the
use of hold register. The above code checks for those restrictions and
programs the USE_HOLD_REG accordingly. Please let me know if there is
any condition that is not handled by the above code.

Thanks,
Thomas.

>
> Best Regards,
> Jaehoon Chung
>
