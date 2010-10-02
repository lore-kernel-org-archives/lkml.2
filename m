Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab0JBUo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 16:44:57 -0400
Received: from tuxonice.net ([74.207.252.127]:45272 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab0JBUo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 16:44:56 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4CA799C5.3060106@tuxonice.net>
Date: Sun, 03 Oct 2010 07:44:53 +1100
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] PM / Hibernate: Modify signature used to mark swap
References: <201009292313.23601.rjw@sisk.pl> <4CA3ADED.6090908@tuxonice.net> <201009300002.03412.rjw@sisk.pl>
In-Reply-To: <201009300002.03412.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 30/09/10 08:02, Rafael J. Wysocki wrote:
> On Wednesday, September 29, 2010, Nigel Cunningham wrote:
>> Hi.
>>
>> On 30/09/10 07:13, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki<rjw@sisk.pl>
>>> Subject: PM / Hibernate: Modify signature used to mark swap
>>>
>>> Since we are adding compression to the kernel's hibernate code,
>>> change signature used by it to mark swap spaces, so that earlier
>>> kernels don't attempt to restore compressed images they cannot
>>> handle.
>>>
>>> Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>
>>> ---
>>>    kernel/power/swap.c |    6 +++---
>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> Index: linux-2.6/kernel/power/swap.c
>>> ===================================================================
>>> --- linux-2.6.orig/kernel/power/swap.c
>>> +++ linux-2.6/kernel/power/swap.c
>>> @@ -29,7 +29,7 @@
>>>
>>>    #include "power.h"
>>>
>>> -#define SWSUSP_SIG	"S1SUSPEND"
>>> +#define HIBERNATE_SIG	"LINHIB0001"
>>>
>>>    /*
>>>     *	The swap map is a data structure used for keeping track of each page
>>> @@ -195,7 +195,7 @@ static int mark_swapfiles(struct swap_ma
>>>    	if (!memcmp("SWAP-SPACE",swsusp_header->sig, 10) ||
>>>    	    !memcmp("SWAPSPACE2",swsusp_header->sig, 10)) {
>>>    		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
>>
>> if no compression
>>
>>> -		memcpy(swsusp_header->sig,SWSUSP_SIG, 10);
>>
>> else
>>
>>> +		memcpy(swsusp_header->sig, HIBERNATE_SIG, 10);
>>
>> ??
>
> I thought about that, but we'll need to drop the old signature when the image
> format changes (I think it will after your patch series) anyway.  And the
> benefit is not really worth it IMO (it only affects people using the in-kernel
> hibernation on x86-64).

Okay. I'm just a little weary because if everything I want to get in 
gets in, we're going to then be changing this signature multiple times. 
I want to eventually reach a situation where we have a 'proper' header 
section to the image that stores (among other things) whether 
compression is enabled and which cryptoapi algorithm is used, allowing a 
person to en/disable compression at runtime without recompiling or 
rebooting. I suppose if I seek to put that stuff in earlier rather than 
later, that will simplify things.

Oh, while I'm writing to you: let's not worry about getting my patches 
in for 2.6.37. I won't be working on them much today, and want to put 
the time into making sure they're right before they get merged. As you 
said - let's seek to get things right first time.

Regards,

Nigel
