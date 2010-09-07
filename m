Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab0IGUfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 16:35:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44276 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758081Ab0IGUfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 16:35:37 -0400
Message-ID: <4C86A1D3.9060703@oracle.com>
Date: Tue, 07 Sep 2010 13:34:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: david.cross@cypress.com
CC: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] west bridge, cyasgadget fixes
References: <1283888647.7250.28.camel@odc-laptop>	 <20100907124855.8ff2a789.randy.dunlap@oracle.com> <1283891334.8865.4.camel@odc-laptop>
In-Reply-To: <1283891334.8865.4.camel@odc-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/10 13:28, David Cross wrote:
> On Tue, 2010-09-07 at 12:48 -0700, Randy Dunlap wrote:
>> On Tue, 07 Sep 2010 12:44:07 -0700 David Cross wrote:
>>
>>> This patch contains update to the gadget driver, some of which are based
>>> on feedback from the Linux community concerning the usage of fat_get_block.
>>> This function call has since been removed along with all file system 
>>> specific calls.
>>> It also contains some fixes for locking issues.
>>> Please let me know if there are issues or concerns with this patch.
>>> Thanks,
>>> David
>>>
>>> Signed-off-by: David Cross <david.cross@cypress.com>
>>
>>
>> Is there a patch or patch series description where the west bridge is described?
> The initial patch had a description of the device itself. I am repeating
> it here for convenience:


{thanks}


> 
>> I'm asking mostly because some of the code (in the block driver patch)
>> looks like it should be in userspace, so I'm wondering why it's in the kernel tree?
> 
> Can you please be more specific concerning what you think should be in
> userspace?

I'll try to find time to review the patches, but reviewing such large patches is
going to be difficult for most people, I think.

>>
>>> diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c linux-next-incl-sdk/drivers/staging/westbridge/astoria/gadget/cyasgadget.c
>>> --- linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-08-31 19:32:51.000000000 -0700
>>> +++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-09-07 11:12:44.000000000 -0700
>>> @@ -154,7 +154,7 @@ static void cy_as_gadget_usb_event_callb
>>>  		#ifndef WESTBRIDGE_NDEBUG
>>>  		ctrlreq = (struct usb_ctrlrequest *)evdata;
>>>  
>>> -		cy_as_hal_print_message("<1>_cy_as_event_usb_setup_packet "
>>> +		printk(KERN_INFO "<1>_cy_as_event_usb_setup_packet "
>>
>> Drop the "<1>" ??
>>
>> But lots of these are purely debug messages anyway, and shouldn't be printed
>> with printk(KERN_INFO ...)
>>
> You are probably right on both counts, I can change this for the next patch.
> The current version in linux-next has both of these issues already
> though, so I am not sure if it makes sense to redo this patch just for
> these items.

That depends on whether you ever want to get the driver out of the staging/ area....
Anyway, there are plenty of other reasons to send more patches, if we can get more
reviews of the current patches done.

>>>  							"received"
>>>  							"bRequestType=0x%x,"
>>>  							"bRequest=0x%x,"
>>


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
