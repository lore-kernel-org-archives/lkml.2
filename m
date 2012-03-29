Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab2C2Ib7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:31:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39647 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2C2Ibx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:31:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAC83ZvKXMGfbM=ay_cPim1_PQk5nDRuC3+csOVfLzOVr9Qg6rg@mail.gmail.com>
References: <1332769480-28069-1-git-send-email-shubhrajyoti@ti.com>
	<1332769480-28069-2-git-send-email-shubhrajyoti@ti.com>
	<CAC83ZvKXMGfbM=ay_cPim1_PQk5nDRuC3+csOVfLzOVr9Qg6rg@mail.gmail.com>
Date: Thu, 29 Mar 2012 14:01:52 +0530
Message-ID: <CAM=Q2csDWfV5wy1LNX2=JP38t7FAtrGxxq9D7v-wX81j0paLSg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] spi/omap: Remove bus_num usage for instance index
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
Cc: Shubhrajyoti D <shubhrajyoti@ti.com>,
        spi-devel-general@lists.sourceforge.net, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benoit Cousson <b-cousson@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tarun,

On Wed, Mar 28, 2012 at 2:15 PM, DebBarma, Tarun Kanti
<tarun.kanti@ti.com> wrote:
> On Mon, Mar 26, 2012 at 7:14 PM, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
>> From: Benoit Cousson <b-cousson@ti.com>
>>
>> bus_num was used to reference the mcspi controller instance in a fixed array.
>> Remove this array and store this information directly inside drvdata structure.
>>
>> bus_num is now just set if the pdev->id is present or with -1 for dynamic
>> allocation by SPI core, but the driver does not access it anymore.
>>
>> Clean some bad comments format, and remove un-needed space.
>>
>> Signed-off-by: Benoit Cousson <b-cousson@ti.com>
>> [Cleanup the OMAP2_MCSPI_MAX_CTRL macro as it is not needed anymore]
>> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
>> ---
>>  drivers/spi/spi-omap2-mcspi.c |   75 ++++++++++++++++++----------------------
>>  1 files changed, 34 insertions(+), 41 deletions(-)
>>
>> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
>> index bb9274c..7785091 100644
>> --- a/drivers/spi/spi-omap2-mcspi.c
>> +++ b/drivers/spi/spi-omap2-mcspi.c
>> @@ -45,9 +45,6 @@
>>
<snip>
>>
>>        tmp = OMAP2_MCSPI_WAKEUPENABLE_WKEN;
>>        mcspi_write_reg(master, OMAP2_MCSPI_WAKEUPENABLE, tmp);
>> -       omap2_mcspi_ctx[master->bus_num - 1].wakeupenable = tmp;
>> +       ctx->wakeupenable = tmp;
> Can't we get rid of tmp now? For example:
> ctx->wakeupenable = OMAP2_MCSPI_WAKEUPENABLE_WKEN;
> mcspi_write_reg(master, OMAP2_MCSPI_WAKEUPENABLE, ctx->wakeupenable);

Yes the tmp variable could be optimized
since it is in addition to the $SUBJECT will do it in a separate patch .
Is that fine?

> --
> Tarun
>
