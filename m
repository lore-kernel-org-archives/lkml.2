Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab1F0Ooi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 10:44:38 -0400
Received: from c60.cesmail.net ([216.154.195.49]:27592 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1F0Ooa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 10:44:30 -0400
Message-ID: <4E089730.1080306@gnu.org>
Date: Mon, 27 Jun 2011 10:44:00 -0400
From: Pavel Roskin <proski@gnu.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] bcma: main.c needs to include <linux/slab.h>
References: <alpine.DEB.2.00.1106261016100.25900@ayla.of.borg>	<BANLkTikSLx6FKvF518s99Q8eRU_WF+cn9A@mail.gmail.com> <BANLkTinGvM79fza-=bFwcbtfFzGHAVKJag@mail.gmail.com>
In-Reply-To: <BANLkTinGvM79fza-=bFwcbtfFzGHAVKJag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2011 10:24 AM, Alexey Dobriyan wrote:
> 2011/6/27 Rafał Miłecki<zajec5@gmail.com>:
>> 2011/6/26 Geert Uytterhoeven<geert@linux-m68k.org>:
>>> m68k allmodconfig:
>>>
>>> drivers/bcma/main.c: In function ‘bcma_release_core_dev’:
>>> drivers/bcma/main.c:68: error: implicit declaration of function ‘kfree’
>>
>> We already include slab.h in:
>> host_pci.c
>> scan.c
>> sprom.c
>>
>> Maybe we can just include this in bcma.h as a better solution?
>
> It isn't better solution.
> It results in situation where unnecessary inclusion will be done.
> Maybe it's not the case now, but it will be in future.

I agree.  kfree() is used in main.c, not in bcma.h.  There is no need 
for all files that include bcma.h to include linux/slab.h, especially 
(but not only) because bcma.h is not a private header.

-- 
Regards,
Pavel Roskin
