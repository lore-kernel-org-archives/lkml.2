Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965146Ab2CTQOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:14:45 -0400
Received: from alpha.licor.com ([208.82.105.155]:59914 "EHLO alpha.licor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760237Ab2CTQOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:14:43 -0400
X-Greylist: delayed 1267 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2012 12:14:43 EDT
Message-ID: <4F68A7C6.9040909@neb.rr.com>
Date: Tue, 20 Mar 2012 10:52:38 -0500
From: ddegraff <ddegraff@neb.rr.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: prakash.pm@ti.com, sshtylyov@mvista.com,
        davinci-linux-open-source@linux.davincidsp.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: arm: davinci: USB ethernet
References: <4F670E6A.9060403@licor.com> <20120320135847.GB4634@kroah.com>
In-Reply-To: <20120320135847.GB4634@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/20/2012 08:58 AM, Greg KH wrote:
> On Mon, Mar 19, 2012 at 05:46:02AM -0500, Darryl wrote:
>> We are currently using a DA850 eval board but will eventually use a
>> custom board to interface host system to davinci using ethernet over
>> USB.  We are using 2.6.37 with real-time patches, but a cursory look
>> (have not been able to build yet) at 3.3-rc7 suggests that the
>> issues noted below still exist.
>>
>> There are currently two issues:
>>
>> - Documentation/usb/hotplug.txt suggests that the drivers should be
>> built as modules so that such things as loading drivers and, in this
>> case, bringing up the interface, can ge moderated in user-space.
>> However, though the code can be build modular, the drivers are never
>> loaded.  I suspect that one or more of the several relevant configs
>> (I see at least these:  USB_MUSB_HDRC, USB_MUSB_DA8XX_GLUE,
>> USB_GADGET, USB_ETH, USB_GPIO_VBUS, NOP_USB_XCEIV, USB_ETH_RNDIS,
>> USB_OTG_UTILS) are required to be built in, but cannot seem to
>> determine the correct ones.
> Do you have a userspace tool that will automatically load the proper
> modules when they show up?
Busybox's mdev is currently intended for that.  I've used udev for other 
projects, but we have a very limited space here.
More important at the moment, however, is getting notifications in 
userspace.
>
> As for unwinding the .config issues, you will have to do this, based on
> your own settings, not much we can do here.
It is my hope that the developers from TI and MonteVista will weigh in 
since I have, so far, unsuccessfully unwound the interactions.
>
>> - Even when compiling all the driver code built-in, neither the
>> plug-in nor plug-out event is propagated to user space, again, so
>> that the interface can be brought up.
> How do you know it isn't showing up?  What are you using to watch for
> it?  Are you using udev?  Something else?  devtmpfs?
As noted above, mdev, which is set as the userspace hotplug script (via 
echo its full path to /proc/sys/kernel/hotplug) which I have slightly 
modified to just log that it is being run, and see no output messages.
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
