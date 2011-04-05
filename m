Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab1DEONA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:13:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49201 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752954Ab1DEOM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:12:58 -0400
Date: Tue, 5 Apr 2011 10:12:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Newall <davidn@davidnewall.com>
cc: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nonzero write bulk status received: -62
In-Reply-To: <4D9ACFC1.4080608@davidnewall.com>
Message-ID: <Pine.LNX.4.44L0.1104051010250.1972-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011, David Newall wrote:

> I'm getting the above error on a recent installation, when printing to a 
> USB connected printer, and only the first half of the page is printed.  
> Searching Google, I found that this is surprisingly common (I was 
> surprised), both using usb parallel converters as well as usb-connected 
> printers, and the only suggestion seems to be to change CUPS's device 
> URI to parallel:/dev/usb/lpN - it's currently 
> usb://OKI%20MICROLINE%20something.  (Even though it seems somewhat 
> bizarre, I am trying the suggestion, but haven't heard the results yet.)
> 
>  From UTSLing I see that error 62 is ETIME, but finding the timer 
> involved requires getting arms-deep into the USB code.

It isn't a software timer; it is a hardware requirement.  ETIME means
the printer failed to acknowledge to a packet sent by the computer
within the required 3-microsecond limit (or whatever the actual value
is -- something like that).

>  I found no 
> discussion on this, and wonder if I just missed it, or if there really 
> is some issue that worth looking at.  Something about extended output 
> and ETIME makes me think it is worth looking at.
> 
> I'd appreciate pointers, either to discussions and solutions that I 
> missed, or to places in the code where I might start looking.

You could capture a usbmon trace.  See the instructions in the kernel 
source file Documentation/usb/usbmon.txt.

Alan Stern

