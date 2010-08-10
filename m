Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab0HJDiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 23:38:23 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43907 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab0HJDiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 23:38:19 -0400
Message-ID: <4C60C9C4.4000902@vflare.org>
Date: Tue, 10 Aug 2010 09:08:44 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] Remove need for explicit device initialization
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>	<1281374816-904-3-git-send-email-ngupta@vflare.org> <AANLkTinsoHUb307N+v6pGfRraHK-epBU70fD0FxPCNup@mail.gmail.com>
In-Reply-To: <AANLkTinsoHUb307N+v6pGfRraHK-epBU70fD0FxPCNup@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2010 12:06 AM, Pekka Enberg wrote:
> On Mon, Aug 9, 2010 at 8:26 PM, Nitin Gupta <ngupta@vflare.org> wrote:
>> Currently, the user has to explicitly write a positive value to
>> initstate sysfs node before the device can be used. This event
>> triggers allocation of per-device metadata like memory pool,
>> table array and so on.
>>
>> We do not pre-initialize all zram devices since the 'table' array,
>> mapping disk blocks to compressed chunks, takes considerable amount
>> of memory (8 bytes per page). So, pre-initializing all devices will
>> be quite wasteful if only few or none of the devices are actually
>> used.
>>
>> This explicit device initialization from user is an odd requirement and
>> can be easily avoided. We now initialize the device when first write is
>> done to the device.
>>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> 
> AFAICT, most hardware block device drivers do things like this in the
> probe function. Why can't we do that for zram as well and drop the
> ->init_done and ->init_lock parts?
> 

I think probe is only for PCI devices? Maybe should hook into open function
in struct block_device_operations. That way, we can also drop init_done and
init_lock parts.

Thanks,
Nitin
