Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab2CSKxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:53:40 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.255.50]:35592 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932177Ab2CSKxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:53:22 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2012 06:53:22 EDT
X-Env-Sender: darryl.degraff@licor.com
X-Msg-Ref: server-7.tower-172.messagelabs.com!1332154009!2153835!1
X-Originating-IP: [208.82.105.217]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <4F670E6A.9060403@licor.com>
Date: Mon, 19 Mar 2012 05:46:02 -0500
From: Darryl <ddegraff@licor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: <prakash.pm@ti.com>, <sshtylyov@mvista.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>
Subject: arm: davinci: USB ethernet
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are currently using a DA850 eval board but will eventually use a 
custom board to interface host system to davinci using ethernet over 
USB.  We are using 2.6.37 with real-time patches, but a cursory look 
(have not been able to build yet) at 3.3-rc7 suggests that the issues 
noted below still exist.

There are currently two issues:

- Documentation/usb/hotplug.txt suggests that the drivers should be 
built as modules so that such things as loading drivers and, in this 
case, bringing up the interface, can ge moderated in user-space.  
However, though the code can be build modular, the drivers are never 
loaded.  I suspect that one or more of the several relevant configs (I 
see at least these:  USB_MUSB_HDRC, USB_MUSB_DA8XX_GLUE, USB_GADGET, 
USB_ETH, USB_GPIO_VBUS, NOP_USB_XCEIV, USB_ETH_RNDIS, USB_OTG_UTILS) are 
required to be built in, but cannot seem to determine the correct ones.

- Even when compiling all the driver code built-in, neither the plug-in 
nor plug-out event is propagated to user space, again, so that the 
interface can be brought up.

I am happy enough to build-in the driver code, but I still need the 
ability to bring up the interface.  I know that I can use a call to
         call_usermodehelper
to get to use-space, but I'd still be faced with where that call would 
work best.

So, I'm wondering if you have suggestions regarding how to proceed.

Thanks,
Darryl

