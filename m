Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab2IGCqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 22:46:39 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:2764
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757738Ab2IGCqi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 22:46:38 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dIc89bh1432Izz1202h1082kzz8275bhz2dh2a8h668h839h93fhe5bhf0ah107ah1288h1155h)
Message-ID: <50496084.3090400@freescale.com>
Date: Fri, 7 Sep 2012 10:48:36 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Huang Shijie <shijie8@gmail.com>, <gregkh@linuxfoundation.org>,
        <alan@linux.intel.com>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] serial: mxs-auart: put the device in mxs_auart_probe()
References: <1346985521-2248-1-git-send-email-shijie8@gmail.com> <1346985521-2248-2-git-send-email-shijie8@gmail.com> <20120907024349.GH26709@S2101-09.ap.freescale.net>
In-Reply-To: <20120907024349.GH26709@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年09月07日 10:43, Shawn Guo 写道:
> On Thu, Sep 06, 2012 at 10:38:41PM -0400, Huang Shijie wrote:
>> We call the get_device() in the mxs_auart_probe().
>> For the balance of the reference count, we should put the
>> device in the mxs_auart_remove().
>>
>> Signed-off-by: Huang Shijie<shijie8@gmail.com>
>> ---
>>   drivers/tty/serial/mxs-auart.c |    1 +
>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
>> index ea5f888..6898413 100644
>> --- a/drivers/tty/serial/mxs-auart.c
>> +++ b/drivers/tty/serial/mxs-auart.c
>> @@ -796,6 +796,7 @@ static int __devexit mxs_auart_remove(struct platform_device *pdev)
>>
>>   	auart_port[pdev->id] = NULL;
>>
>> +	put_device(s->dev);
>>   	clk_put(s->clk);
>>   	free_irq(s->irq, s);
>>   	kfree(s);
> So the error path of probe needs function fixing too, right?
>
OK.

Send out the new version right now.


Huang Shijie

