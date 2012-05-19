Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab2ESPpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 11:45:42 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:42595 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756283Ab2ESPpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 11:45:40 -0400
Message-ID: <4FB7C028.80406@xenotime.net>
Date: Sat, 19 May 2012 08:45:44 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH -next] usb: add usb.h stubs for CONFIG_USB not enabled
References: <20120518184943.2c762e8441e53ea24748d1b8@canb.auug.org.au> <4FB6ED55.6090805@xenotime.net> <20120519005031.GA27613@kroah.com> <4FB6FFBF.6000509@xenotime.net> <4FB7AB4D.5040900@mvista.com>
In-Reply-To: <4FB7AB4D.5040900@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2012 07:16 AM, Sergei Shtylyov wrote:

> Hello.
> 
> On 19-05-2012 6:04, Randy Dunlap wrote:
> 
>> From: Randy Dunlap<rdunlap@xenotime.net>
> 
>> Add stubs for some usb core functions when CONFIG_USB
>> is not enabled.  This fixes these comedi build errors:
> 
>> ERROR: "usb_deregister" [drivers/staging/comedi/comedi.ko] undefined!
>> ERROR: "usb_register_driver" [drivers/staging/comedi/comedi.ko] undefined!
> 
>> Signed-off-by: Randy Dunlap<rdunlap@xenotime.net>
>> ---
>> I am only adding the stubs that are needed for comedi to build.
>> I expect that more stubs will be needed as more build errors are
>> found.  It seems to me that linux/usb.h might need more (major)
>> moving of lines to support more stubs in the future.
> 
>>   Documentation/usb/error-codes.txt |    2 ++
>>   include/linux/usb.h               |   24 +++++++++++++++++++++++-
>>   2 files changed, 25 insertions(+), 1 deletion(-)
>>
>> --- linux-next-20120518.orig/include/linux/usb.h
>> +++ linux-next-20120518/include/linux/usb.h
>> @@ -10,7 +10,7 @@
>>
>>   #ifdef __KERNEL__
>>
>> -#include<linux/errno.h>         /* for -ENODEV */
>> +#include<linux/errno.h>         /* for -ENODEV, -ENOSYS */
>>   #include<linux/delay.h>    /* for mdelay() */
>>   #include<linux/interrupt.h>    /* for in_interrupt() */
>>   #include<linux/list.h>        /* for struct list_head */
>> @@ -515,6 +515,8 @@ static inline struct usb_device *interfa
>>       return to_usb_device(intf->dev.parent);
>>   }
>>
>> +#if defined(CONFIG_USB) || defined(CONFIG_USB_MODULE)
> 
>    You can use IS_ENABLED(CONFIG_USB) instead of these two now.


I know, but I chose not to do that in case the patch
needs to be applied to some earlier kernels.

-- 
~Randy
