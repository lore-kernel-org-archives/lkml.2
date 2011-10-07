Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719Ab1JGKHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:07:04 -0400
Received: from mail.infrascan.de ([188.40.84.136]:50309 "EHLO infrascan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759653Ab1JGKHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:07:03 -0400
Message-ID: <4E8ECF44.7060506@sensortherm.de>
Date: Fri, 07 Oct 2011 12:07:00 +0200
From: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: balbi@ti.com
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de> <20111006120830.GN1714@legolas.emea.dhcp.ti.com> <4E8EB6EE.8040700@sensortherm.de> <20111007083856.GB10910@legolas.emea.dhcp.ti.com>
In-Reply-To: <20111007083856.GB10910@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Am 07.10.2011 10:38, schrieb Felipe Balbi:

>>>> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
>>>> index dd1571d..f623f3d 100644
>>>> --- a/include/linux/usb/gadget.h
>>>> +++ b/include/linux/usb/gadget.h
>>>> @@ -15,6 +15,7 @@
>>>>   #ifndef __LINUX_USB_GADGET_H
>>>>   #define __LINUX_USB_GADGET_H
>>>>
>>>> +#include<linux/device.h>
>>>
>>> this is not part of $SUBJECT
>>>
>>
>> changed git message
>
> not enough. adding another header is not part of this patch. You need to
> let us know why you need this new header there and you need add proper
> spacing there.
>


There is a space in the orginal patch.

Should i make a seperate patch for this?

In the header gadget.h are some stuff used, but not declared.

My compile errors without device.h:

   CC      drivers/usb/gadget/acm_ms.o
In file included from include/linux/usb/composite.h:38,
                  from drivers/usb/gadget/u_serial.h:15,
                  from drivers/usb/gadget/acm_ms.c:20:
include/linux/usb/gadget.h:491: error: field ‘dev’ has incomplete type
include/linux/usb/gadget.h: In function ‘set_gadget_data’:
include/linux/usb/gadget.h:495: error: implicit declaration of function 
‘dev_set_drvdata’
include/linux/usb/gadget.h: In function ‘get_gadget_data’:
include/linux/usb/gadget.h:497: error: implicit declaration of function 
‘dev_get_drvdata’
include/linux/usb/gadget.h: In function ‘dev_to_usb_gadget’:
include/linux/usb/gadget.h:500: warning: type defaults to ‘int’ in 
declaration of ‘__mptr’
include/linux/usb/gadget.h:500: warning: initialization from 
incompatible pointer type
include/linux/usb/gadget.h: At top level:
include/linux/usb/gadget.h:781: error: field ‘driver’ has incomplete type
In file included from drivers/usb/gadget/composite.c:26,
                  from drivers/usb/gadget/acm_ms.c:44:
include/linux/device.h:705: error: conflicting types for ‘dev_get_drvdata’
include/linux/usb/gadget.h:497: note: previous implicit declaration of 
‘dev_get_drvdata’ was here
In file included from drivers/usb/gadget/acm_ms.c:44:
drivers/usb/gadget/composite.c:1261: error: field name not in record or 
union initializer
drivers/usb/gadget/composite.c:1261: error: (near initialization for 
‘composite_driver.driver’)
make[3]: *** [drivers/usb/gadget/acm_ms.o] Error 1
make[2]: *** [drivers/usb/gadget] Error 2
make[1]: *** [drivers/usb] Error 2
make: *** [drivers] Error 2

