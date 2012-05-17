Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab2EQC5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 22:57:38 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:32106
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756097Ab2EQC5h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 22:57:37 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz9371I542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Bob Liu <lliubbo@gmail.com>
Date: Wed, 16 May 2012 22:58:00 -0400
Subject: RE: [PATCH] input: rotary: Init wake according to platform
 pm_wakeup flag.
Thread-Topic: [PATCH] input: rotary: Init wake according to platform
 pm_wakeup flag.
Thread-Index: Ac0zkh0T6nEvfBSpRFqVz/ipr0KGNQARnJtg
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D16F64F84E68@NWD2CMBX1.ad.analog.com>
References: <1337157383-13631-1-git-send-email-sonic.zhang@analog.com>
 <20120516183038.GA14471@core.coreip.homeip.net>
In-Reply-To: <20120516183038.GA14471@core.coreip.homeip.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,


>-----Original Message-----
>From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
>Sent: Thursday, May 17, 2012 2:31 AM
>To: Zhang, Sonic
>Cc: linux-input@vger.kernel.org; LKML; uclinux-dist-devel@blackfin.uclinux.org
>Subject: Re: [PATCH] input: rotary: Init wake according to platform pm_wakeup
>flag.
>
>Hi Sonic,
>
>On Wed, May 16, 2012 at 04:36:23PM +0800, sonic.zhang@analog.com wrote:
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> Rotary can't be used as a wakeup source in all Blackfin processors.
>>
>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>> ---
>>  drivers/input/misc/bfin_rotary.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/input/misc/bfin_rotary.c b/drivers/input/misc/bfin_rotary.c
>> index 1c4146f..bb1971c 100644
>> --- a/drivers/input/misc/bfin_rotary.c
>> +++ b/drivers/input/misc/bfin_rotary.c
>> @@ -182,7 +182,7 @@ static int __devinit bfin_rotary_probe(struct
>platform_device *pdev)
>>      bfin_write_CNT_CONFIG(bfin_read_CNT_CONFIG() | CNTE);
>>
>>      platform_set_drvdata(pdev, rotary);
>> -    device_init_wakeup(&pdev->dev, 1);
>> +    device_init_wakeup(&pdev->dev, pdata->pm_wakeup);
>
>I do not see pm_wakeup in bfin_rotary_platform_data.

The patch against the bfin_rotary.h under blackfin architecture folder will be sent out soon by Bob Liu.

Regards,

Sonic

>
>Thanks.
>
>--
>Dmitry


