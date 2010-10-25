Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab0JYOQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:16:57 -0400
Received: from nm1-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.224]:20949 "HELO
	nm1-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753164Ab0JYOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:16:56 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Oct 2010 10:16:55 EDT
X-Yahoo-Newman-Id: 193084.48160.bm@omp1021.mail.ukl.yahoo.com
X-Yahoo-SMTP: ugveKluswBD09EJ1iMni59kz5ZdZ6LLBWw--
X-YMail-OSG: nKiOZJoVM1lomDDlN0xITrZmqejdEHOBUqAojGNR_dzFNrF
 Tu3gP3Hlj8GPwJ4pQvmviVb4Ti4HJLd8RtbQRMYD.ZCSxhgsnyM6HF9RlcNe
 tGvPfo5d8UOR01wksRsV4j4Zsku.B8K3lD9ItTanl7reTljJZKcCPXXWeF9p
 dlZ3WNLLni8wUyAAlioYPYvvx0gY7LHEbetxWF_741UKyvJLlvw4QO6jqfb6
 w.XV5ho0c3LPWiBR_UmIbcJGH6OE1_e95fu_oR_OxB3hUL7z13dbBOwaqXPg
 tkqRIHmd2
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4CC5900A.2050209@users.sourceforge.net>
Date: Mon, 25 Oct 2010 15:11:22 +0100
From: Hin-Tak Leung <htl10@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.8.1.24) Gecko/20100301 SeaMonkey/1.1.19
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Serafeim Zanikolas <sez@debian.org>, herton@mandriva.com.br,
        linville@tuxdriver.com, joe@perches.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: rtl818x: request DMA-able memory
References: <1287952327-9924-1-git-send-email-sez@debian.org> <4CC5851D.1040204@lwfinger.net>
In-Reply-To: <4CC5851D.1040204@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Larry Finger wrote:
> On 10/24/2010 03:32 PM, Serafeim Zanikolas wrote:
>> Despite the indicated intention in comment, the kmalloc() call was not
>> explicitly requesting memory from ZONE_DMA.
>>
>> Signed-off-by: Serafeim Zanikolas <sez@debian.org>
>> ---
>>  drivers/net/wireless/rtl818x/rtl8187_dev.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
>> index 38fa824..771794d 100644
>> --- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
>> +++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
>> @@ -1343,7 +1343,8 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
>>  	priv->is_rtl8187b = (id->driver_info == DEVICE_RTL8187B);
>>  
>>  	/* allocate "DMA aware" buffer for register accesses */
>> -	priv->io_dmabuf = kmalloc(sizeof(*priv->io_dmabuf), GFP_KERNEL);
>> +	priv->io_dmabuf = kmalloc(sizeof(*priv->io_dmabuf),
>> +				  GFP_DMA | GFP_KERNEL);
>>  	if (!priv->io_dmabuf) {
>>  		err = -ENOMEM;
>>  		goto err_free_dev;
> 
> ACK.
> 
> Larry

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

I had a quick look for similiar constructs and AFAIK only the b43/b43legacy 
drivers uses DMA buffers. Seems to be a rare practice. Is that something we 
should or should not do?

Hin-Tak
