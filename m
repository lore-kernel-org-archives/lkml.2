Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934556Ab0EEQIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:08:35 -0400
Received: from mail-ew0-f222.google.com ([209.85.219.222]:35945 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593Ab0EEQIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:08:34 -0400
Message-ID: <4BE1973D.5040206@vflare.org>
Date: Wed, 05 May 2010 21:35:17 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <greg@kroah.com>, Minchan Kim <minchan.kim@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ramzswap: Eliminate stale data in compressed memory
References: <1273067156-2574-1-git-send-email-ngupta@vflare.org> <alpine.LFD.2.00.1005050809490.5478@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005050809490.5478@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 08:44 PM, Linus Torvalds wrote:
> 
> 
> On Wed, 5 May 2010, Nitin Gupta wrote:
>>
>> ramzswap driver creates RAM based block devices which can be
>> used (only) as swap disks. Pages swapped to these disks are
>> compressed and stored in memory itself.
> 
> Ok, this patch series looks way better, if only because it looks less 
> hacky.
> 
> That said, I absolutely _hate_ the f*cking notifier model that takes 
> "type" flags. It's a disgrace. It's a horrible horrible model.
> 

You mean you didn't like the 'swap type' value passed around by notifier
calls, as here:
 "blocking_notifier_call_chain(&swapon_notify_list, type, swap_file);" ?

> I'd much rather bind a nice "swap_operations" structure to the device, and 
> have that structure have function pointers for the different operations. 
> No stupid "operation type codes". Real, honest-to-goodness function 
> pointers.
> 

I think such 'swap_operations' structure will be have to be part of
block_device_operations, so we may access it from swap_entry_free()
where a swap slot is freed. This will also get rid of all this notifier
stuff.

The patch you nacked did something similar: it add 'swap_slot_free_callback'
directly to block_device_operations. Without such change, I could not think
of any way to do away with notifiers.


> The notifier layer is a total piece of sh*t. I'm sorry I ever merged it, 
> and I'm _doubly_ sorry that it's use is so horribly widespread. It's a 
> mistake.

Thanks,
Nitin
