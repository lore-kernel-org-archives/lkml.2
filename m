Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab1F0Onu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 10:43:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41437 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1F0Onp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 10:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OKcLZi0yoffbqS1R9+rpPfwZ9sMSRlS3cM9ViHbwzynzm3O/mmkd2FSTySciHsXuk2
         6HwQ6xmj/lz514snNmvFjPWXg4WP/D3jMpCdds1i+OD9EqhaO9Ktr3R6CW23MeyFfG99
         4avNBtJ6n6QkrnUF92Vd3vH1VRoM6fHFwhM3s=
MIME-Version: 1.0
In-Reply-To: <BANLkTinGvM79fza-=bFwcbtfFzGHAVKJag@mail.gmail.com>
References: <alpine.DEB.2.00.1106261016100.25900@ayla.of.borg>
	<BANLkTikSLx6FKvF518s99Q8eRU_WF+cn9A@mail.gmail.com>
	<BANLkTinGvM79fza-=bFwcbtfFzGHAVKJag@mail.gmail.com>
Date: Mon, 27 Jun 2011 16:43:41 +0200
Message-ID: <BANLkTikVtWe0jB_jLeP1YZTEKSYA97gdqQ@mail.gmail.com>
Subject: Re: [PATCH -next] bcma: main.c needs to include <linux/slab.h>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-wireless@vger.kernel.org,
        linux-next@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 27 czerwca 2011 16:24 użytkownik Alexey Dobriyan
<adobriyan@gmail.com> napisał:
> 2011/6/27 Rafał Miłecki <zajec5@gmail.com>:
>> 2011/6/26 Geert Uytterhoeven <geert@linux-m68k.org>:
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

Scanning code is required for every BCMA board, so we already include
linux/slab.h on every configuration. No matter if this is PCI host
board, or SoC, or whatever we will support in the future.
Now we discovered this is also needed in main.c, which will be always compiled.

That's why I think it's safe to include linux/slab.h in bcma_private.h.
But if that's just my opinion, everybody think it's wrong idea, I'm OK with it.

-- 
Rafał
