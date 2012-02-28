Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965422Ab2B1Ljw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 06:39:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35325 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965342Ab2B1Lju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 06:39:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of sshtylyov@mvista.com designates 10.205.133.208 as permitted sender) smtp.mail=sshtylyov@mvista.com
Message-ID: <4F4CBCB6.7080901@mvista.com>
Date: Tue, 28 Feb 2012 15:38:30 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Meng Zhang <meng.zhang@mediatek.com>
CC: mdharm-usb@one-eyed-alien.net, phil@ipom.com, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Mass Storage: Add MediaTek MT6276M device entry
References: <4F4C998D.4000805@mediatek.com>
In-Reply-To: <4F4C998D.4000805@mediatek.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> US_DEBUGP("Huawei mode set result is %d\n", result);
> return 0;
> }
> +
> +/* switch MediaTek MT6276M to COM port mode */
> +int usb_stor_mediatek_mt6276m_init(struct us_data *us)
> +{
> + const unsigned char rezero_msg[] = {

    Unfortunately, when I reply to messages with "format=flowed", source 
formatting is spoiled. :-(

> + 0x55, 0x53, 0x42, 0x43, 0x78, 0x56, 0x34, 0x12,

    All indentation here should be done with tabs, not tab and two spaces.

> + 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x06, 0xf0,
> + 0x01, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> + 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
> + };

WBR, Sergei
