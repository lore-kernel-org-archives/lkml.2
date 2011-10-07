Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901Ab1JGLOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:14:41 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:55248 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759826Ab1JGLOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:14:40 -0400
Message-ID: <4E8EDEEE.2090907@ru.mvista.com>
Date: Fri, 07 Oct 2011 15:13:50 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: balbi@ti.com
CC: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>, gregkh@suse.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de> <20111006120830.GN1714@legolas.emea.dhcp.ti.com> <4E8EB6EE.8040700@sensortherm.de> <20111007083856.GB10910@legolas.emea.dhcp.ti.com> <4E8ECF44.7060506@sensortherm.de> <20111007101414.GN10910@legolas.emea.dhcp.ti.com>
In-Reply-To: <20111007101414.GN10910@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.10.2011 14:14, Felipe Balbi wrote:

>>>>>> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
>>>>>> index dd1571d..f623f3d 100644
>>>>>> --- a/include/linux/usb/gadget.h
>>>>>> +++ b/include/linux/usb/gadget.h
>>>>>> @@ -15,6 +15,7 @@
>>>>>>   #ifndef __LINUX_USB_GADGET_H
>>>>>>   #define __LINUX_USB_GADGET_H
>>>>>>
>>>>>> +#include<linux/device.h>

>>>>> this is not part of $SUBJECT


>>>> changed git message

>>> not enough. adding another header is not part of this patch. You need to
>>> let us know why you need this new header there and you need add proper
>>> spacing there.



>> There is a space in the orginal patch.

>> Should i make a seperate patch for this?

>> In the header gadget.h are some stuff used, but not declared.

>> My compile errors without device.h:

>>    CC      drivers/usb/gadget/acm_ms.o
>> In file included from include/linux/usb/composite.h:38,
>>                   from drivers/usb/gadget/u_serial.h:15,
>>                   from drivers/usb/gadget/acm_ms.c:20:
>> include/linux/usb/gadget.h:491: error: field ‘dev’ has incomplete type
>> include/linux/usb/gadget.h: In function ‘set_gadget_data’:
>> include/linux/usb/gadget.h:495: error: implicit declaration of
>> function ‘dev_set_drvdata’
>> include/linux/usb/gadget.h: In function ‘get_gadget_data’:
>> include/linux/usb/gadget.h:497: error: implicit declaration of
>> function ‘dev_get_drvdata’
>> include/linux/usb/gadget.h: In function ‘dev_to_usb_gadget’:
>> include/linux/usb/gadget.h:500: warning: type defaults to ‘int’ in
>> declaration of ‘__mptr’
>> include/linux/usb/gadget.h:500: warning: initialization from
>> incompatible pointer type
>> include/linux/usb/gadget.h: At top level:
>> include/linux/usb/gadget.h:781: error: field ‘driver’ has incomplete type
>> In file included from drivers/usb/gadget/composite.c:26,
>>                   from drivers/usb/gadget/acm_ms.c:44:
>> include/linux/device.h:705: error: conflicting types for ‘dev_get_drvdata’
>> include/linux/usb/gadget.h:497: note: previous implicit declaration
>> of ‘dev_get_drvdata’ was here
>> In file included from drivers/usb/gadget/acm_ms.c:44:
>> drivers/usb/gadget/composite.c:1261: error: field name not in record
>> or union initializer
>> drivers/usb/gadget/composite.c:1261: error: (near initialization for
>> ‘composite_driver.driver’)
>> make[3]: *** [drivers/usb/gadget/acm_ms.o] Error 1
>> make[2]: *** [drivers/usb/gadget] Error 2
>> make[1]: *** [drivers/usb] Error 2
>> make: *** [drivers] Error 2

> I believe Sergei had that patch already, but it wasn't applied for some
> reason. Sergei, do you happen to remember the outcome of that patch ?

    It has been apllied allright to 3.1-rc1. :-)

WBR, Sergei

