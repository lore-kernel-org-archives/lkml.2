Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab2B2GEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 01:04:22 -0500
Received: from mailgw01.mediatek.com ([218.249.47.110]:40930 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751603Ab2B2GEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 01:04:20 -0500
From: =?gb2312?B?TWVuZyBaaGFuZyAo1cXDyCk=?= <Meng.Zhang@mediatek.com>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Josua Dietze <digidietze@draisberghof.de>,
        Phil Dibowitz <phil@ipom.com>, USB list <linux-usb@vger.kernel.org>,
        USB Storage list <usb-storage@lists.one-eyed-alien.net>,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Wed, 29 Feb 2012 14:03:59 +0800
Subject: RE: [PATCH] USB: Mass Storage: Add MediaTek MT6276M device entry
Thread-Topic: [PATCH] USB: Mass Storage: Add MediaTek MT6276M device entry
Thread-Index: Acz2l7h8qyKGHblKSPK4ibnt/a+EVAADj8RA
Message-ID: <0D3EFCAF29FAA54FB91286E54DF1085C230485078D@MTKMBS30.mediatek.inc>
References: <4F4C998D.4000805@mediatek.com>
 <Pine.LNX.4.44L0.1202281028350.1456-100000@iolanthe.rowland.org>
 <0D3EFCAF29FAA54FB91286E54DF1085C23048506EF@MTKMBS30.mediatek.inc>
 <CAA6KcBAy0iu1KU9Nc0TTB77XNth_h+4M-Uqw96nkP-ypX2jAAA@mail.gmail.com>
In-Reply-To: <CAA6KcBAy0iu1KU9Nc0TTB77XNth_h+4M-Uqw96nkP-ypX2jAAA@mail.gmail.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1T64lSO032168

Hi Matthew,

Thanks for your comment, I've tested some other products and found their entries in /lib/udev/rules.d/40-usb_modeswitch.rules.
So, does usb_modeswitch comes with latest distributions by default? 

Thanks!

BR.
Meng Zhang


-----Original Message-----
From: Matthew Dharm [mailto:mdharm-usb@one-eyed-alien.net] 
Sent: Wednesday, February 29, 2012 12:08 PM
To: Meng Zhang (ÕÅÃÈ)
Cc: Alan Stern; Josua Dietze; Phil Dibowitz; USB list; USB Storage list; Kernel development list
Subject: Re: [PATCH] USB: Mass Storage: Add MediaTek MT6276M device entry

Devices should not be added to unusual_devs.h unless the device CANNOT use the usb_modeswitch method.  This most commonly applies when the device's usb-storage emulation is poor, and the probing commands sent by usb-storage cause the device to crash.

It is much more convenient for users to just upgrade their usb_modeswitch utility than it is for them to upgrade a kernel, which is much more difficult and much more rare.  As for 'input command manually', that is what udev scripts are for.

If this can be handled from userspace by usb_modeswitch, then that is where it should be done.

Matt

2012/2/28 Meng Zhang (ÕÅÃÈ) <Meng.Zhang@mediatek.com>:
> Hi Alan,
>
> As far as I know, many other devices used this init function in unusual_devs.h for their "ZeroCD" feature, and I think this is more convenient than let device user install utilities like usb_modeswitch and input command manually.
>
> Thanks.
>
> BR.
> Meng Zhang
>
> -----Original Message-----
> From: linux-usb-owner@vger.kernel.org 
> [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Alan Stern
> Sent: Tuesday, February 28, 2012 11:31 PM
> To: Meng Zhang (ÕÅÃÈ)
> Cc: Josua Dietze; Matthew Dharm; Phil Dibowitz; USB list; USB Storage 
> list; Kernel development list
> Subject: Re: [PATCH] USB: Mass Storage: Add MediaTek MT6276M device 
> entry
>
> On Tue, 28 Feb 2012, Meng Zhang wrote:
>
>> from: Meng Zhang <meng.zhang@mediatek.com>
>>
>> 1. Add entrys for mediatek MT6276M in unusual_devs.h
>>
>> 2. Add init function for mediatek MT6276M to switch to COM port mode
>>
>> 3. usb-devices outputs after running with this patch:
>> T:  Bus=02 Lev=01 Prnt=01 Port=05 Cnt=01 Dev#= 48 Spd=480 MxCh= 0
>> D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
>> P:  Vendor=0e8d ProdID=00a1 Rev=02.00
>> S:  Manufacturer=MediaTek Inc
>> S:  Product=Product
>> C:  #Ifs= 3 Cfg#= 1 Atr=80 MxPwr=500mA
>> I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=02 Prot=01 Driver=option
>> I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>> I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>>
>> 4. patch based on branch:
>>       
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>>
>>
>> Signed-off-by: Meng Zhang <meng.zhang@mediatek.com>
>
> Nowadays, aren't such things handled in userspace by the usb_modeswitch program rather than in the kernel driver?
>
> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html



--
Matthew Dharm
Maintainer, USB Mass Storage driver for Linux
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
