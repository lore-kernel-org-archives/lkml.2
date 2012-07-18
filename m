Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab2GRNxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 09:53:54 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:62398 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751276Ab2GRNxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 09:53:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnAIACm/BlBbdWOb/2dsb2JhbABFhWqrEiKIHIEHgiABAQQBIw8BBR0jAQULCxgCAgUWCwICCQMCAQIBRQYNAQUCAQEXh2wKB6sBkwCBIIoghT2BEgOVRJAJgmGBXQ
X-IronPort-AV: E=Sophos;i="4.77,610,1336341600"; 
   d="scan'208";a="545346047"
Message-ID: <5006BFEC.1010407@igalia.com>
Date: Wed, 18 Jul 2012 15:53:48 +0200
From: =?UTF-8?B?TWlndWVsIEfDs21leg==?= <magomez@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: don@syst.com.br, mjg@redhat.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 v2] classmate-laptop: Add support for Classmate V4
 accelerometer.
References: <cover.1340976795.git.magomez@igalia.com> <39ac42c709e498fbef4f0f0f24edc5331e5f4473.1340976795.git.magomez@igalia.com> <20120717224749.GA20813@nautilus.holoscopio.com>
In-Reply-To: <20120717224749.GA20813@nautilus.holoscopio.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jun 29, 2012 at 03:39:48PM +0200, Miguel Gómez wrote:
>> Classmate V4 laptop includes a new accelerometer that can't be handled by
>> previous driver. This patch adds a new driver to handle it.
>>
>> Signed-off-by: Miguel Gómez <magomez@igalia.com>
>
> Hi, Miguel.
>
> This seems OK to me. Thanks for this work. Do you have the other
> functionality of the driver working? I am interested to know if you have
> the function buttons working.

Hi Thadeu

I've been giving a look to the buttons code. Currently they are not 
working because the hardware id reported by the device (FNBT0000) is not 
the same as the one defined by the driver (FnBT0000), as you an one of 
my colleagues commented in this thread:

https://lkml.org/lkml/2011/6/21/341

I've replaced the id in the driver to FNBT0000 and it made the buttons 
work like a charm (enabling control of the backlight and LAN as well). 
To ensure compatibility with older versions of the kernel, a new id can 
be added (FNBT0000) besides the existent one (FnBT0000), and that works 
as well (as proposed in the thread).

It seems that this problem got a bit forgotten in the lists. Quoting 
yourself from the last email in the thread:

> I am copying the acpi list and Len Brown to see if they can tell us
> which one should be the right solution:
>
> 1) reverting the patch in acpica that puts all names in uppercase
> 2) using a case-insensitive match in acpi bus driver
> 3) using uppercase name in classmate-laptop driver

I think the easiest and less risky way to fix this is by adding a new 
hardware id (as proposed in the thread's patch), as it doesn't add any 
side effects (that the other solutions might add), and it doesn't break 
the behaviour of the old code.

What do you think?

Regards!

-- 
Miguel Gómez
Igalia - http://www.igalia.com


