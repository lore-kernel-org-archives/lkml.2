Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1GUQdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:33:47 -0400
Received: from c60.cesmail.net ([216.154.195.49]:57950 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab1GUQdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:33:44 -0400
Message-ID: <4E2854E5.3020905@gnu.org>
Date: Thu, 21 Jul 2011 12:33:41 -0400
From: Pavel Roskin <proski@gnu.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bug in BCMA: device_unregister causing "NULL pointer dereference
 at"
References: <CACna6rxAKMp-2wqwz4k4S3nTkY_3Qz7=hEZk9F2Zig7T5kp_HA@mail.gmail.com> <CACna6rwPqeW5Bhc7A0FnkCaRq-a-nA4ziUQdoiakN_DvMyL_RQ@mail.gmail.com>
In-Reply-To: <CACna6rwPqeW5Bhc7A0FnkCaRq-a-nA4ziUQdoiakN_DvMyL_RQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2011 03:18 AM, Rafał Miłecki wrote:

>> So when I unload bcma after I got driver (b43) for 0x812 core, I get
>> NULL pointer dereference.
>>
>> Any tip, why does it happen?
>
> I've tracked where does crash really happen (kobject_del does not
> really say much). The real forwardtrace is:
> device_unregister → device_del → kobject_del → kobj_kset_leave →
> kobj_kset_leave → list_del_init
>
> If you take a look at list_del_init, it touches "prev" and "next". So
> I've added some debugging:
> pr_info("core->dev.kobj.entry.prev: 0x%p\n", core->dev.kobj.entry.prev);
> pr_info("core->dev.kobj.entry.next: 0x%p\n", core->dev.kobj.entry.next);

There are options for debugging that you may want to enable:

CONFIG_DEBUG_LIST
CONFIG_DEBUG_OBJECTS
CONFIG_DEBUG_KOBJECT

Actually, consider enabling most debug options as possible, except 
perhaps the most time consuming (such as CONFIG_DEBUG_KMEMLEAK).  Maybe 
you are passing a freed pointer or something.

Print the pointers you are passing to device_register() and 
device_unregister().

> [  612.819320] bcma: core->dev.kobj.entry.prev: 0x  (null)

You may want to make it a macro and print it in most bcma functions.

-- 
Regards,
Pavel Roskin
