Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab0LGPLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:11:51 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:50836 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752184Ab0LGPLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:11:49 -0500
X-Greylist: delayed 1086 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Dec 2010 10:11:49 EST
Message-ID: <4CFE4C96.4000702@mvista.com>
Date: Tue, 07 Dec 2010 18:02:46 +0300
From: Valentine Barshak <vbarshak@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] USB: HID: Fix race between disconnect and hiddev_ioctl
References: <20101206145141.GA8462@mvista.com> <alpine.LNX.2.00.1012071546040.14806@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1012071546040.14806@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Mon, 6 Dec 2010, Valentine Barshak wrote:
>
>   
>> A USB HID device can be disconnected at any time.
>> If this happens right before or while hiddev_ioctl is in progress,
>> the hiddev_ioctl tries to access invalid hiddev->hid pointer.
>> When the hid device is disconnected, the hiddev_disconnect()
>> ends up with a call to hid_device_release() which frees
>> hid_device, but doesn't set the hiddev->hid pointer to NULL.
>> If the deallocated memory region has been re-used by the kernel,
>> this can cause a crash or memory corruption.
>>
>> Since disconnect can happen at any time, we can't initialize
>> struct hid_device *hid = hiddev->hid at the beginning of ioctl
>> and then use it.
>>
>> This change checks hiddev->exist flag while holding
>> the existancelock and uses hid_device only if it exists.
>>     
>
> The code duplication isn't really particularly nice, but I don't see any 
> way around it that wouldn't complicate things even more.
>
> I will be applying the patches, thanks.
>   
Thanks!
> (BTW your patches didn't reach mail mailbox, I had to dig them out from 
> mailinglist -- did you receive bounces by any chance?).
>   
Yes, they did bounce.
Thanks,
Val.
> Thanks,
>
>   

