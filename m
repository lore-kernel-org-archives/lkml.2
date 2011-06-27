Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1F0QuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 12:50:14 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3656 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab1F0QuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 12:50:06 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4E08B4AA.409@broadcom.com>
Date: Mon, 27 Jun 2011 18:49:46 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "Linux Kernel Development" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] bcma: main.c needs to include <linux/slab.h>
References: <alpine.DEB.2.00.1106261016100.25900@ayla.of.borg>
 <BANLkTikSLx6FKvF518s99Q8eRU_WF+cn9A@mail.gmail.com>
 <BANLkTinGvM79fza-=bFwcbtfFzGHAVKJag@mail.gmail.com>
 <BANLkTikVtWe0jB_jLeP1YZTEKSYA97gdqQ@mail.gmail.com>
In-Reply-To: <BANLkTikVtWe0jB_jLeP1YZTEKSYA97gdqQ@mail.gmail.com>
X-WSS-ID: 62166A453B49537859-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2011 04:43 PM, Rafał Miłecki wrote:
> W dniu 27 czerwca 2011 16:24 użytkownik Alexey Dobriyan
> <adobriyan@gmail.com>  napisał:
>> 2011/6/27 Rafał Miłecki<zajec5@gmail.com>:
>>> 2011/6/26 Geert Uytterhoeven<geert@linux-m68k.org>:
>>>> m68k allmodconfig:
>>>>
>>>> drivers/bcma/main.c: In function ‘bcma_release_core_dev’:
>>>> drivers/bcma/main.c:68: error: implicit declaration of function ‘kfree’
>>> We already include slab.h in:
>>> host_pci.c
>>> scan.c
>>> sprom.c
>>>
>>> Maybe we can just include this in bcma.h as a better solution?
>> It isn't better solution.
>> It results in situation where unnecessary inclusion will be done.
>> Maybe it's not the case now, but it will be in future.
> Scanning code is required for every BCMA board, so we already include
> linux/slab.h on every configuration. No matter if this is PCI host
> board, or SoC, or whatever we will support in the future.
> Now we discovered this is also needed in main.c, which will be always compiled.
>
> That's why I think it's safe to include linux/slab.h in bcma_private.h.
> But if that's just my opinion, everybody think it's wrong idea, I'm OK with it.

My rule of thumb is: Header file a.h may only include header b.h when 
a.h needs some definition from b.h. Convenience is never a good reason 
for nested includes.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


