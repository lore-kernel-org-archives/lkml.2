Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1L1BEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 20:04:10 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62108 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab1L1BEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 20:04:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAMPhdO8=L1KGmn_OihoMmMWNDahZ5+3u7M+BNuT3FcSfExHm1w@mail.gmail.com>
References: <1324974344.2351.5.camel@phoenix>
	<CAMPhdO_QL3ahf4+F70Bg7FHKq5mrbbofN_BTz8dpcBLea9BNAw@mail.gmail.com>
	<25B60CDC2F704E4E9D88FFD52780CB4C05EC64DBD3@SC-VEXCH1.marvell.com>
	<CAMPhdO8=L1KGmn_OihoMmMWNDahZ5+3u7M+BNuT3FcSfExHm1w@mail.gmail.com>
Date: Wed, 28 Dec 2011 09:04:07 +0800
Message-ID: <CAN1soZyatf2u4fVk-=U_Sz4wcVwP7qFaiZK4CR3rosbXeQObvA@mail.gmail.com>
Subject: Re: [PATCH RESEND] ARM: pxa: fix error handling in pxa2xx_drv_pcmcia_probe
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <hzhuang1@marvell.com>, Axel Lin <axel.lin@gmail.com>,
        "linux-pcmcia@lists.infradead.org" <linux-pcmcia@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 5:25 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Tue, Dec 27, 2011 at 5:18 PM, Haojian Zhuang <hzhuang1@marvell.com> wrote:
>>
>> ________________________________________
>> From: Eric Miao [eric.y.miao@gmail.com]
>> Sent: Tuesday, December 27, 2011 5:11 PM
>> To: Axel Lin
>> Cc: linux-kernel@vger.kernel.org; Haojian Zhuang; Russell King; linux-arm-kernel@lists.infradead.org; linux-pcmcia@lists.infradead.org
>> Subject: Re: [PATCH RESEND] ARM: pxa: fix error handling in pxa2xx_drv_pcmcia_probe
>>
>> On Tue, Dec 27, 2011 at 4:25 PM, Axel Lin <axel.lin@gmail.com> wrote:
>>> If pxa2xx_drv_pcmcia_add_one fails, it will go to err1 error path.
>>> Add a missing clk_put in the error path.
>>>
>>> Checking the ret value after the for loop is redundant, it is always false.
>>> Thus remove the redundant checking.
>>>
>>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>>
>> Acked-by: Eric Miao <eric.y.miao@gmail.com>
>>
>>> ---
>>>  drivers/pcmcia/pxa2xx_base.c |   12 +++---------
>>>  1 files changed, 3 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/pcmcia/pxa2xx_base.c b/drivers/pcmcia/pxa2xx_base.c
>>> index a87e272..64d433e 100644
>>> --- a/drivers/pcmcia/pxa2xx_base.c
>>> +++ b/drivers/pcmcia/pxa2xx_base.c
>>> @@ -328,21 +328,15 @@ static int pxa2xx_drv_pcmcia_probe(struct platform_device *dev)
>>>                        goto err1;
>>>        }
>>>
>>> -       if (ret) {
>>> -               while (--i >= 0)
>>> -                       soc_pcmcia_remove_one(&sinfo->skt[i]);
>>> -               kfree(sinfo);
>>> -               clk_put(clk);
>>> -       } else {
>>> -               pxa2xx_configure_sockets(&dev->dev);
>>> -               dev_set_drvdata(&dev->dev, sinfo);
>>> -       }
>>> +       pxa2xx_configure_sockets(&dev->dev);
>>> +       dev_set_drvdata(&dev->dev, sinfo);
>>>
>>>        return 0;
>>>
>>>  err1:
>>>        while (--i >= 0)
>>>                soc_pcmcia_remove_one(&sinfo->skt[i]);
>>> +       clk_put(clk);
>>>        kfree(sinfo);
>>>  err0:
>>>        return ret;
>>> --
>>> 1.7.5.4
>>>
>>>
>>>
>> Wait a minute.
>>
>> The original code will check whether pxa2xx_drv_pcmcia_add_one() successful. If it fails, we'll remove all devices that we registered.
>>
>> But Axel removed these code. Why?
>
> If it fails, it will jump to err1 anyway. The check there is redundant.
>
Applied
