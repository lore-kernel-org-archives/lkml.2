Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2LSI42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 03:56:28 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:41411 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2LSI4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 03:56:20 -0500
Message-ID: <50D180E6.3010305@ahsoftware.de>
Date: Wed, 19 Dec 2012 09:55:02 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Vincent Palatin <vpalatin@chromium.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
Subject: Re: [rtc-linux] [PATCH] rtc: recycle id when unloading a rtc driver
References: <1343951605-25722-1-git-send-email-vpalatin@chromium.org> <20121218164659.a3d3655a.akpm@linux-foundation.org> <50D16EA3.8040803@ahsoftware.de> <20121218234543.786a2211.akpm@linux-foundation.org> <50D1730D.7010108@ahsoftware.de> <20121219002722.87438a08.akpm@linux-foundation.org>
In-Reply-To: <20121219002722.87438a08.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.12.2012 09:27, schrieb Andrew Morton:
> On Wed, 19 Dec 2012 08:55:57 +0100 Alexander Holler <holler@ahsoftware.de> wrote:
>
>>>
>>> I'm all confused.
>>>
>>> Lothar's patch simply reverts Vincent's patch.  And that appears to be
>>> the correct thing to so, as the ida_simple_remove() in
>>> rtc_device_release() should be sufficient.
>>>
>>> But apparently that doesn't work, because Vincent was seeing the RTC
>>> ID's increment rather than getting reused.
>>>
>>> Is it the case that rtc_device_release() is not being called sometimes?
>>> If so, under what circumstances?
>>
>> Maybe something (sysfs or whatever) still has a reference to it. Vincent
>> should check that.
>>
>> But I'm sure the ID will be recycled with that put_device() in
>> unregister because I've got the same warning as Lothar did when
>> (porperly) removing an RTC (with kernel 3.7).
>
> If, as appears to be the case, rtc_device_release() is not being called
> then we're also leaking memory.  So yes please, it would be good if
> someone who can reproduce the IDs-dont-decrease problem could dive in
> and work out why ->release() isn't begin called.

Unlikely, as I've worked hard to get one of the first drivers for 
pluggable RTCs into the kernel. ;)
I think every sane kernel has them statically linked in and it's likely 
a problem of the RTC-driver Vincent experienced that with.

Regards,

Alexander
