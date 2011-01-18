Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab1ARCov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 21:44:51 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:6564 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753385Ab1ARCou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 21:44:50 -0500
Message-ID: <4D34FEAA.3000402@bluewatersys.com>
Date: Tue, 18 Jan 2011 15:44:58 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Xu, Hong" <Hong.Xu@atmel.com>
CC: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, jamie@jamieiles.com,
        jacmet@sunsite.dk, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] MTD: atmel_nand: Add DMA support to access Nandflash
References: <hong.xu@atmel.com> <1295248809-30334-2-git-send-email-hong.xu@atmel.com> <4D34A37E.1060300@bluewatersys.com> <4D34C5BF.2070107@bluewatersys.com> <4C79549CB6F772498162A641D92D5328D9FE16@penmb01.corp.atmel.com>
In-Reply-To: <4C79549CB6F772498162A641D92D5328D9FE16@penmb01.corp.atmel.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2011 02:43 PM, Xu, Hong wrote:
> Hi Ryan,
>> -----Original Message-----
>> From: Ryan Mallon [mailto:ryan@bluewatersys.com]
>> Sent: Tuesday, January 18, 2011 6:42 AM
>> To: Xu, Hong
>> Cc: linux-mtd@lists.infradead.org; linux-arm-kernel@lists.infradead.org;
>> linux-kernel@vger.kernel.org; jamie@jamieiles.com; jacmet@sunsite.dk;
>> Ferre, Nicolas
>> Subject: Re: [PATCH] MTD: atmel_nand: Add DMA support to access Nandflash
>>
>> root@snapper:~$ dmesg | grep -i dma
>> [    0.850000] atmel_nand atmel_nand: Failed to request DMA channel
>> [    0.860000] atmel_nand atmel_nand: No DMA support for NAND access.
>> [    1.530000] at_hdmac at_hdmac: Atmel AHB DMA Controller ( cpy slave ),
>> 8 channels
>>
>>
>> It looks like the registration for the DMA controller happens after the
>> NAND driver probe and so the request is failing. I had a quick look, but
>> I can't see anything that would change this in more recent kernels. Any
>> ideas?
>>
> You got the point. A [Git Pull] has been sent, see
> http://article.gmane.org/gmane.linux.kernel/1088240/match=dmaengine+update
> 
> In this patch, subsys_initcall will be used so DMA engine will be initialized before NAND driver.
> Thanks.

Thanks, that fixed it.

I have tried this under 2.6.33 on a custom SAM9G45 based board with a
512MiB NAND part, with 2kB pages and 128kB blocks using both raw MTD
access and the YAFFS2 filesystem and it appears to work correctly.

Tested-by: Ryan Mallon <ryan@bluewatersys.com>

Can you please update for the changes I suggested.

Thanks,
~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
