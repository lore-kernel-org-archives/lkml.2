Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760809Ab2EKQ2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:28:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61880 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760559Ab2EKQ2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:28:14 -0400
Message-ID: <4FAD3E18.5000700@lwfinger.net>
Date: Fri, 11 May 2012 11:28:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Alberto Lago Ballesteros <saniukeokusainaya@gmail.com>,
        Adrian <agib@gmx.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 166/167] [PATCH] staging: r8712u: Fix regression caused by
 commit 8c213fa
References: <20120509055029.588587017@decadent.org.uk>  <20120509055052.452419913@decadent.org.uk>  <20120509194859.GE15527@herton-ThinkPad-T420> <1336706470.8274.435.camel@deadeye>
In-Reply-To: <1336706470.8274.435.camel@deadeye>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 10:21 PM, Ben Hutchings wrote:
> On Wed, 2012-05-09 at 12:49 -0700, Herton Ronaldo Krzesinski wrote:
>> On Wed, May 09, 2012 at 06:53:15AM +0100, Ben Hutchings wrote:
>>> 3.2-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Larry Finger<Larry.Finger@lwfinger.net>
>>>
>>> commit 2080913e017ab9f88379d93fd09546ad95faf87b upstream.
> [...]
>>> --- a/drivers/staging/rtl8712/usb_intf.c
>>> +++ b/drivers/staging/rtl8712/usb_intf.c
>>> @@ -30,6 +30,7 @@
>>>
>>>   #include<linux/usb.h>
>>>   #include<linux/module.h>
>>> +#include<linux/firmware.h>
>>>
>>>   #include "osdep_service.h"
>>>   #include "drv_types.h"
>>> @@ -620,6 +621,10 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
>>>   	struct _adapter *padapter = netdev_priv(pnetdev);
>>>   	struct usb_device *udev = interface_to_usbdev(pusb_intf);
>>>
>>> +	if (padapter->fw_found)
>>> +		release_firmware(padapter->fw);
>>> +	/* never exit with a firmware callback pending */
>>> +	wait_for_completion(&padapter->rtl8712_fw_ready);
>>
>> We also need to apply commit ee6aeff71e2f16b9fe95ce908d098c169e0f4004
>> after this, due to the possible invalid padapter dereference.
> [...]
>
> That 'fix' makes no sense since netdev_priv() never returns NULL.
>
> Larry, you should remove the test for pAdapter completely, or if pnetdev
> can somehow be NULL then test *that*.

Thanks. I have a patch under testing.

Larry

