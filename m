Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab0GINGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:06:48 -0400
Received: from senator.holtmann.net ([87.106.208.187]:37744 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab0GINGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:06:46 -0400
Subject: Re: [PATCH 1/1] Bluetooth: hidp: Add support for hidraw  
 HIDIOCGFEATURE   and HIDIOCSFEATURE
From: Marcel Holtmann <marcel@holtmann.org>
To: Alan Ott <alan@signal11.us>
Cc: David S Miller <davem@davemloft.net>, Jiri Kosina <jkosina@suse.cz>,
       Michael Poole <mdpoole@troilus.org>, Bastien Nocera <hadess@hadess.net>,
       Eric Dumazet <eric.dumazet@gmail.com>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <4C371DE8.9020002@signal11.us>
References: <1276467601-9066-1-git-send-email-alan@signal11.us>
	 <1278623485.10421.73.camel@localhost.localdomain>
	 <4C369CDC.9080104@signal11.us>
	 <1278662497.10421.94.camel@localhost.localdomain>
	 <4C371DE8.9020002@signal11.us>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 10:06:30 -0300
Message-ID: <1278680790.10421.106.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> >>> I looked at this and I am bit worried that this should not be done in
> >>> this detail in the HIDP driver. Essentially HIDP is a pure transport
> >>> driver. It should not handle all these details. Can we make this a bit
> >>> easier for the transport drivers to support such features?
> >>>        
> >> I put these changes (most notably the addition of hidp_get_raw_report())
> >> in hidp because that's where the parallel function
> >> hidp_output_raw_report() was already located. I figured the input should
> >> go with the output. That said, if there's a better place for both of
> >> them (input and output) to go, let me know where you think it should be,
> >> and I'll get them moved into the proper spot.
> >>
> >> I'm not sure what you mean about HIDP being a pure transport driver.
> >>      
> > what is usb-hid.ko doing here? I would expect a bunch of code
> > duplication with minor difference between USB and Bluetooth.
>
> usbhid doesn't have a lot of code for hidraw. Two functions are involved:
>      usbhid_output_raw_report()
>          - calls usb_control_msg() with Get_Report
>      usbhid_get_raw_report()
>          - calls usb_control_msg() with Set_Report
>              OR
>          - calls usb_interrupt_msg() on the Ouput pipe.
> 
> This is of course easier than bluetooth because usb_control_msg() is 
> synchronous, even when requesting reports, mostly because of the nature 
> of USB, where the request and response are part of the same transfer.
> 
> For Bluetooth, it's a bit more complicated since the kernel treats it 
> more like a networking interface (and indeed it is). My understanding is 
> that to make a synchronous transfer in bluetooth, one must:
>      - send the request packet
>      - block (wait_event_*())
>      - when the response is received in the input handler, wake_up_*().
> 
> There's not really any code duplication, mostly because initiating 
> synchronous USB transfers (input and output) is easy (because of the 
> usb_*_msg() functions), while making synchronous Bluetooth transfers 
> must be done manually. If there's a nice, convenient, synchronous 
> function in Bluetooth similar to usb_control_msg() that I've missed, 
> then let me know, as it would simplify this whole thing.

there is not and I don't think we ever get one. My question here was
more in the direction why HID core is doing these synchronously in the
first place. Especially since USB can do everything async as well.

Regards

Marcel


