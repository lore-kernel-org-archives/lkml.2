Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab2KVTio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:38:44 -0500
Received: from netrider.rowland.org ([192.131.102.5]:45428 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965070Ab2KVTiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:38:19 -0500
Date: Thu, 22 Nov 2012 10:38:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: naveen yadav <yad.naveen@gmail.com>
cc: linux-kernel@vger.kernel.org, <majordomo@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <marcel@holtmann.org>,
        <padovan@profusion.mobi>
Subject: Re: USB 2.0: No giveback comes for one submitted URB
In-Reply-To: <CAJ8eaTwTM3b2wTa9=o3POy-dcP6hkE_DdoAVX06PBuPDhz4W6w@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1211221036030.345-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2012, naveen yadav wrote:

> Hi,
> 
> we are using 3.2.2 version of kernel.
> 
> When Bluetooth(connected to USB 2.0) is suspended, urb->use_count
> value does not become zero and eventually there is a continuous wait
> in wait_event() of usb_kill_urb().
>           wait_event(usb_kill_urb_queue, atomic_read(&urb->use_count) == 0);
> 
> urb_count is incremented at only one place in usb_hcd_submit_urb() and

That's how it is _supposed_ to work.  You have discovered that
something else increments urb->use_count.

> decremented in usb_hcd_giveback_urb(). (Also, in error case inside
> usb_hcd_submit_urb()). After taking print of  urb->use_count at all
> these places, I see, even without connecting the Bluetooth device
> urb_count is incremented while below execution has never been
> decremented.

> .....
> [    3.490000] ====>[usb_hcd_giveback_urb][1626] urb->use_count = 0
> pipe=2147484032 [vid=0x1d6b] [pid=0x0002][devno=1]
> [    3.540000] ====>[usb_hcd_submit_urb][1482] urb->use_count = 2
> pipe=1077969280 [vid=0x1d6b] [pid=0x0002][devno=1]
> [    3.540000] ====>[usb_hcd_giveback_urb][1626] urb->use_count = 1
> pipe=1077969280 [vid=0x1d6b] [pid=0x0002][devno=1]

Now you need to find out what other code has changed urb->use_count and
fix it.

Alan Stern

