Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab1HJMDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:03:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46575 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab1HJMDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:03:37 -0400
MIME-Version: 1.0
In-Reply-To: <CABb+yY1Be3q+5QVaLYnonOUq1VtjyCZMKp0S1yryjF2HRyqoSw@mail.gmail.com>
References: <1312898301-7229-1-git-send-email-padma.v@samsung.com>
	<CABb+yY1Be3q+5QVaLYnonOUq1VtjyCZMKp0S1yryjF2HRyqoSw@mail.gmail.com>
Date: Wed, 10 Aug 2011 17:33:36 +0530
Message-ID: <CAAgF-Bf=K8M9Qp8EwFTuUY06H4SPNY5cW2Ct3K9FecMLvBHmuA@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] spi: s3c64xx: Use clkdev for bus clock lookup
From: padma venkat <padma.kvr@gmail.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Padmavathi Venna <padma.v@samsung.com>, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,

On Tue, Aug 9, 2011 at 6:13 PM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> On Tue, Aug 9, 2011 at 7:28 PM, Padmavathi Venna <padma.v@samsung.com> wrote:
>> SPI driver is modified to lookup the bus clock using the
>> alias name instead of getting clock name and clock
>> number from platform data.
> Cool.
>
>> Driver is modified to get the best source clock among the
>> available source clocks for the required frequency.
> I am not sure if this driver should be deciding which clock is 'best' for it.
> Because ...
> 1) Usually it's the board designer who decides which clock to run at
>  what speed based upon target device. So ideally, based upon use-case
> the driver should simply get the 'best' clock from board via platform in a
> format that is compliant to the 'generic clock api'.
As per your comment I modified the code for board designer to supply the
required list of source clocks. If this list is NULL then it  uses the
all available
clock sources. I will resubmit this patch.
> 2) We are not changing source clock rates(and we should not).
>  So the 'best' clock found, might still be way off in accuracy. And when we
> can't anyway guarantee accuracy, why not leave the decision to
> the board designer who might, say, select the source clock good enough
> to be useful to more than one controller yet not absolutely accurate for any ?
Yes. We are not getting the accurate frequency but we are able to get
best frequency.
> 3) It keeps enabled 3 unused clocks all the time.
I modified the  code to enable only the best source clock. I will
resubmit this patch.
>
>
>> diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi_s3c64xx.c
>> index 8945e20..d7c979d 100644
>> --- a/drivers/spi/spi_s3c64xx.c
>> +++ b/drivers/spi/spi_s3c64xx.c
>> @@ -132,6 +132,9 @@
>>  #define RXBUSY    (1<<2)
>>  #define TXBUSY    (1<<3)
>>
>> +#define MAX_SPI_BUS_CLK (4)
>> +#define MAX_PSR (256)
>
> Btw,
>
>  #define MAX_SPI_BUS_CLK 4
>  #define MAX_PSR 256
>
> is safe ... even safer than with two on!
Modified.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
