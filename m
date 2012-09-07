Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab2IGCl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 22:41:58 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:19747
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546Ab2IGCl5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 22:41:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dIc89bh1432Izz1202h1082kzz8275bh8275dhz2dh2a8h668h839h93fhd25he5bhf0ah107ah1288h1155h)
Message-ID: <50495F6F.4040800@freescale.com>
Date: Fri, 7 Sep 2012 10:43:59 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Huang Shijie <shijie8@gmail.com>, <gregkh@linuxfoundation.org>,
        <alan@linux.intel.com>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] serial: mxs-auart: fix the wrong setting order
References: <1346985521-2248-1-git-send-email-shijie8@gmail.com> <20120907023841.GF26709@S2101-09.ap.freescale.net>
In-Reply-To: <20120907023841.GF26709@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年09月07日 10:38, Shawn Guo 写道:
> On Thu, Sep 06, 2012 at 10:38:40PM -0400, Huang Shijie wrote:
>> After set the AUART_CTRL0_CLKGATE, the UART will gate all the clocks off.
>> So the following line will not take effect.
>>         ................................................................
>>   	writel(AUART_INTR_RXIEN | AUART_INTR_RTIEN | AUART_INTR_CTSMIEN,
>>   			u->membase + AUART_INTR_CLR);
>>         ................................................................
>>
>> To fix this issue, the patch moves this gate-off line to
>> the end of setting registers.
>>
>> Signed-off-by: Huang Shijie<shijie8@gmail.com>
> Acked-by: Shawn Guo<shawn.guo@linaro.org>
>
> Are you experiencing any user visible problem with this bug?
>
I do not experience any user problem.
I found this bug when i tried to add DMA support for MXS-AUART.

Best Regards
Huang Shijie


> Regards,
> Shawn
>
>> ---
>>   drivers/tty/serial/mxs-auart.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
>> index dafeef2..ea5f888 100644
>> --- a/drivers/tty/serial/mxs-auart.c
>> +++ b/drivers/tty/serial/mxs-auart.c
>> @@ -457,11 +457,11 @@ static void mxs_auart_shutdown(struct uart_port *u)
>>
>>   	writel(AUART_CTRL2_UARTEN, u->membase + AUART_CTRL2_CLR);
>>
>> -	writel(AUART_CTRL0_CLKGATE, u->membase + AUART_CTRL0_SET);
>> -
>>   	writel(AUART_INTR_RXIEN | AUART_INTR_RTIEN | AUART_INTR_CTSMIEN,
>>   			u->membase + AUART_INTR_CLR);
>>
>> +	writel(AUART_CTRL0_CLKGATE, u->membase + AUART_CTRL0_SET);
>> +
>>   	clk_disable_unprepare(s->clk);
>>   }
>>
>> -- 
>> 1.7.4.4
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-serial" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


