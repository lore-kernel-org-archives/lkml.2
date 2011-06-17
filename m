Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab1FQK6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 06:58:25 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39339 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab1FQK6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 06:58:21 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinWzJ22NrVGofSNvgOcQePD1BKAuA@mail.gmail.com>
References: <1306360653-6196-1-git-send-email-per.forlin@linaro.org>
	<1306360653-6196-3-git-send-email-per.forlin@linaro.org>
	<BANLkTinWzJ22NrVGofSNvgOcQePD1BKAuA@mail.gmail.com>
Date: Fri, 17 Jun 2011 12:58:20 +0200
Message-ID: <BANLkTikb=gXBpxSvgdg4Ni1sXj99m7zj2g@mail.gmail.com>
Subject: Re: [PATCH v4 02/12] omap_hsmmc: use original sg_len for dma_unmap_sg
From: Per Forlin <per.forlin@linaro.org>
To: "S, Venkatraman" <svenkatr@ti.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-dev <linaro-dev@lists.linaro.org>,
        David Vrabel <david.vrabel@csr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2011 15:16, S, Venkatraman <svenkatr@ti.com> wrote:
> On Thu, May 26, 2011 at 3:27 AM, Per Forlin <per.forlin@linaro.org> wrote:
>> Don't use the returned sg_len from dma_map_sg() as inparameter
>> to dma_unmap_sg(). Use the original sg_len for both dma_map_sg
>> and dma_unmap_sg.
>>
>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>> ---
>>  drivers/mmc/host/omap_hsmmc.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
>> index 259ece0..ad3731a 100644
>> --- a/drivers/mmc/host/omap_hsmmc.c
>> +++ b/drivers/mmc/host/omap_hsmmc.c
>> @@ -959,7 +959,8 @@ static void omap_hsmmc_dma_cleanup(struct omap_hsmmc_host *host, int errno)
>>        spin_unlock(&host->irq_lock);
>>
>>        if (host->use_dma && dma_ch != -1) {
>> -               dma_unmap_sg(mmc_dev(host->mmc), host->data->sg, host->dma_len,
>> +               dma_unmap_sg(mmc_dev(host->mmc), host->data->sg,
>> +                       host->data->sg_len,
>>                        omap_hsmmc_get_dma_dir(host, host->data));
>>                omap_free_dma(dma_ch);
>>        }
>> @@ -1343,7 +1344,7 @@ static void omap_hsmmc_dma_cb(int lch, u16 ch_status, void *cb_data)
>>                return;
>>        }
>>
>> -       dma_unmap_sg(mmc_dev(host->mmc), data->sg, host->dma_len,
>> +       dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
>>                omap_hsmmc_get_dma_dir(host, data));
>>
>>        req_in_progress = host->req_in_progress;
>> --
>> 1.7.4.1
>>
>
> Reviewed-by: Venkatraman S <svenkatr@ti.com>
>
> Perhaps this doesn't belong to $FEATURE and can be posted as a separate patch ?
Yes, I will resend it as a separate patch.

Thanks,
Per
