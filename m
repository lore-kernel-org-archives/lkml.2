Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965525Ab2B1MAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 07:00:06 -0500
Received: from mailgw02.mediatek.com ([218.249.47.111]:44152 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965344Ab2B1MAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 07:00:04 -0500
From: =?gb2312?B?TWVuZyBaaGFuZyAo1cXDyCk=?= <Meng.Zhang@mediatek.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "phil@ipom.com" <phil@ipom.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "usb-storage@lists.one-eyed-alien.net" 
	<usb-storage@lists.one-eyed-alien.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 28 Feb 2012 19:59:54 +0800
Subject: RE: [PATCH] USB: Mass Storage: Add MediaTek MT6276M device entry
Thread-Topic: [PATCH] USB: Mass Storage: Add MediaTek MT6276M device entry
Thread-Index: Acz2Dc/k8g+684CjRXaO81IaucKJtwAAYEAg
Message-ID: <0D3EFCAF29FAA54FB91286E54DF1085C23048506D5@MTKMBS30.mediatek.inc>
References: <4F4C998D.4000805@mediatek.com> <4F4CBCB6.7080901@mvista.com>
In-Reply-To: <4F4CBCB6.7080901@mvista.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1SC0FYV026682

Hi, about the indentation I saw in initializers.c is also tab with 2 spaces.. should I change this to 2 tabs manually?

Thanks!

BR.
Meng Zhang

-----Original Message-----
From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Sergei Shtylyov
Sent: Tuesday, February 28, 2012 7:39 PM
To: Meng Zhang (ÕÅÃÈ)
Cc: mdharm-usb@one-eyed-alien.net; phil@ipom.com; stern@rowland.harvard.edu; linux-usb@vger.kernel.org; usb-storage@lists.one-eyed-alien.net; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Mass Storage: Add MediaTek MT6276M device entry

Hello.

On 28-02-2012 13:08, Meng Zhang wrote:

> from: Meng Zhang <meng.zhang@mediatek.com>

> 1. Add entrys for mediatek MT6276M in unusual_devs.h

> 2. Add init function for mediatek MT6276M to switch to COM port mode

> 3. usb-devices outputs after running with this patch:
> T: Bus=02 Lev=01 Prnt=01 Port=05 Cnt=01 Dev#= 48 Spd=480 MxCh= 0
> D: Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs= 1
> P: Vendor=0e8d ProdID=00a1 Rev=02.00
> S: Manufacturer=MediaTek Inc
> S: Product=Product
> C: #Ifs= 3 Cfg#= 1 Atr=80 MxPwr=500mA
> I: If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=02 Prot=01 Driver=option
> I: If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I: If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option

> 4. patch based on branch:
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

    This information (4) should be under the --- tear line.

> Signed-off-by: Meng Zhang <meng.zhang@mediatek.com>
[...]

> diff --git a/drivers/usb/storage/initializers.c
> b/drivers/usb/storage/initializers.c
> index 105d900..44985a1 100644
> --- a/drivers/usb/storage/initializers.c
> +++ b/drivers/usb/storage/initializers.c
> @@ -104,3 +104,30 @@ int usb_stor_huawei_e220_init(struct us_data *us) 
> US_DEBUGP("Huawei mode set result is %d\n", result); return 0; }
> +
> +/* switch MediaTek MT6276M to COM port mode */ int 
> +usb_stor_mediatek_mt6276m_init(struct us_data *us) {  const unsigned 
> +char rezero_msg[] = {

    Unfortunately, when I reply to messages with "format=flowed", source formatting is spoiled. :-(

> + 0x55, 0x53, 0x42, 0x43, 0x78, 0x56, 0x34, 0x12,

    All indentation here should be done with tabs, not tab and two spaces.

> + 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x06, 0xf0, 0x01, 0x03, 0x00, 
> + 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
> + 0x00 };

WBR, Sergei
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
