Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab0L1WZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 17:25:09 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41946 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab0L1WZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 17:25:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Xbzi7gI0ZwLo/P8WiZb7X/Mx+ekHwhVW5K3wgr50zkTzb/FjzwVbsIynA4m6c3v9Sk
         2UTk7OqGCaNvKLtgnB8+rn6YKZ24DtB+BXSZ4huJDK0BPmKqkmONjGo3nBxWXlQ+sVoU
         jioUbrDdxFi62G+kOENkraMBMuCysz03Fzxf0=
MIME-Version: 1.0
In-Reply-To: <4D1A6021.2010905@zytor.com>
References: <4D0C072D.1040201@kernel.org>
	<4D1A46D2.1000702@zytor.com>
	<AANLkTik7Zbc4KW0rS1h=qsLwm-NCxHNjLUZnLi1t0sr5@mail.gmail.com>
	<4D1A6021.2010905@zytor.com>
Date: Tue, 28 Dec 2010 14:25:06 -0800
X-Google-Sender-Auth: y-tLjDXTyJohSyWNprEOfLDA0dI
Message-ID: <AANLkTike8D0Kgfdvc4h4VjEevdT2QnQKoBN5SnymmSWO@mail.gmail.com>
Subject: Re: [PATCH 0/3] memblock related top down
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 2:09 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/28/2010 01:36 PM, Yinghai Lu wrote:
>> On Tue, Dec 28, 2010 at 12:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 12/17/2010 04:58 PM, Yinghai Lu wrote:
>>>> Please check
>>>>
>>>> Those three patches to make memblock allocation more top to down.
>>>>
>>>
>>> Please explain what you mean with "more top to down".  Not what the code
>>> does, but what is the goal of the patchset.
>>
>> for example first node with 16g ram, it is into two parts: [0, 2g),
>> and [4g, 18g).
>>
>> alloc_bootmem will get allocation from [0, 2g) always until we have
>> can not find more.
>>
>> with third patch, it will try to get from [4g, 18g) at first.
>>
>> second patch is need to applied before third patch, because old way
>> happenly get under 4g for generic bootmem under 4g
>>
>> First one is trying not to put page table for [0, 4g) under 512M.
>>
>
> The goal of this is to free up low memory for DMA and kdump, I presume?

yes.  otherwise if we put pgtable around 512M, then we have no chance
to allocate 512M for kdump under 896M.
if we put pgtable near 2g <assume [2g, 4g) for mmio),  We can make it happen.

later 6 patches will put try to pgtable on local node.

Thanks
