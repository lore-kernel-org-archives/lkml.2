Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab0H3V4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:56:30 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:44334 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263Ab0H3V4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:56:20 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Aug 2010 17:56:19 EDT
Message-ID: <4C7C2780.8040003@simon.arlott.org.uk>
Date: Mon, 30 Aug 2010 22:49:52 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100605 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: cxacru usb_bulk_msg() firmware upload 36x slower with OHCI vs.
 UHCI
References: <Pine.LNX.4.44L0.0911221714160.31173-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911221714160.31173-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/11/09 22:17, Alan Stern wrote:
> On Sun, 22 Nov 2009, Simon Arlott wrote:
>> I've tried sending 64 and 2048 bytes at a time, with the same speed
>> (4ms and 128ms), so that time is just a coincidence.
> 
> These timings indicate that one packet is getting transmitted every 4 
> frames.  In theory the slowness could be caused by either the host 
> controller or the device, but you'd need a bus analyzer to tell which.  
> Certainly there's no good reason for the controller to run that slowly, 
> but there's also no good reason for the device to run that slowly only 
> with OHCI.
> 
>> Submitting it all as multiple asynchronous URBs in one go doesn't help
>> either. I've been trying to get EHCI working too (via two different
>> high speed hubs) but that's not working even if I add long delays.
> 
> Have you tried using a non-high-speed hub, or forcing the port into 
> full speed and adding a hub?  That is, does the presence of a hub with 
> OHCI make any difference?

Something has changed in the kernel between the last time I looked at
this issue and now. On both my OHCI hardware the firmware initialisation
runs at the same speed as UHCI did. It's even working via a hub on EHCI.

This may have something to do with cxacru trying to use an interrupt
transfer for a bulk endpoint, which now returns an error if
CONFIG_USB_DEBUG is enabled...

Commit f661c6f8c67bd55e93348f160d590ff9edf08904 is in urgent need of a
printk(); a patch follows this email.

-- 
Simon Arlott
