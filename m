Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab1F0Otr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 10:49:47 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:64093 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1F0Otl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 10:49:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=queGCGninwy6KspFn+5lwO+pLUbmj/n8T1gQaQUaYH2HuuQALHcSSAf0mNle+r6thJ
         m9UxtqcnONTlnswP3kvloWn+0VQF3nhfr8fiSX2dfellZU2fmcx/vpzpvBOkniRuiybr
         VIVi70gChmpyoGEPuqFzHhJ5ao4A4BBasPCH4=
MIME-Version: 1.0
In-Reply-To: <4E089730.1080306@gnu.org>
References: <alpine.DEB.2.00.1106261016100.25900@ayla.of.borg>
	<BANLkTikSLx6FKvF518s99Q8eRU_WF+cn9A@mail.gmail.com>
	<BANLkTinGvM79fza-=bFwcbtfFzGHAVKJag@mail.gmail.com>
	<4E089730.1080306@gnu.org>
Date: Mon, 27 Jun 2011 16:49:39 +0200
Message-ID: <BANLkTi=XYQYee_AoKOXXmO4krwscP_qo4g@mail.gmail.com>
Subject: Re: [PATCH -next] bcma: main.c needs to include <linux/slab.h>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/27 Pavel Roskin <proski@gnu.org>:
> On 06/27/2011 10:24 AM, Alexey Dobriyan wrote:
>>
>> 2011/6/27 Rafał Miłecki<zajec5@gmail.com>:
>>>
>>> 2011/6/26 Geert Uytterhoeven<geert@linux-m68k.org>:
>>>>
>>>> m68k allmodconfig:
>>>>
>>>> drivers/bcma/main.c: In function ‘bcma_release_core_dev’:
>>>> drivers/bcma/main.c:68: error: implicit declaration of function ‘kfree’
>>>
>>> We already include slab.h in:
>>> host_pci.c
>>> scan.c
>>> sprom.c
>>>
>>> Maybe we can just include this in bcma.h as a better solution?
>>
>> It isn't better solution.
>> It results in situation where unnecessary inclusion will be done.
>> Maybe it's not the case now, but it will be in future.
>
> I agree.  kfree() is used in main.c, not in bcma.h.  There is no need for
> all files that include bcma.h to include linux/slab.h, especially (but not
> only) because bcma.h is not a private header.

You ignore the fact I clarified my idea to use bcma_private.h instead of bcma.h.

-- 
Rafał
