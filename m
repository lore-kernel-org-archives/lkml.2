Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab1JMO6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:58:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59246 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752058Ab1JMO6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:58:40 -0400
Date: Thu, 13 Oct 2011 10:58:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Markus Rechberger <mrechberger@gmail.com>
cc: Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
In-Reply-To: <CA+O4pCL-QDUJNyfGueb163wNgO4dE+bn5ykmOxfHsoHaaH3oyA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1110131032400.2026-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Markus Rechberger wrote:

> And for those who are curious about the logfiles:
> Not working one as proposed by Alan that the full buffer size should
> be split into 2 requests:
> 
> ffff8800b38d9f00 1231540351 S Bi:2:013:1 -115 12288 <
> ffff8800b38d96c0 1231540404 S Bi:2:013:1 -115 11776 <
> ffff8800b38d9cc0 1231540440 S Bi:2:013:1 -115 12288 <
> ffff880002ede600 1231540496 S Bi:2:013:1 -115 11776 <
> ffff8800b38d9f00 1231545491 C Bi:2:013:1 0 12288 = 7a1a0840 1ca8353c
> 004b80ec 4de08401 2f0227f8 34005e7e 80181dfd 1a8f700a
> ffff88007d51fb40 1231545875 S Bi:2:013:1 -115 12288 <
> ffff8800b38d96c0 1231551861 C Bi:2:013:1 0 11776 = 5244e386 a7800000
> 010642ea 35bfbba5 373e738b cc035a73 c328a1ff 4da728ce
> ffff880002ede0c0 1231556173 S Bi:2:013:1 -115 11776 <
> ffff8800b38d9cc0 1231558618 C Bi:2:013:1 0 12288 = db91aae9 2d2532f3
> 2e37448a fb36c213 55dda2ad 243122b2 261edb06 875848ac
> 
> 
> 12288 = 7a1a0840 every Line with 12288 should start with 47 (MPEG-TS Sync byte)
> 
> The working one which allocate 7000 bytes more (oh really big memory
> pressure now!)  than this castrated USBFS interface allows.

Sarcasm won't help convince anybody to do anything.

> ffff88003ac37240 992178919 S Bi:2:013:1 -115 24064 <
> ffff88003ac37000 992178953 S Bi:2:013:1 -115 24064 <
> ffff88003ac37c00 992178980 S Bi:2:013:1 -115 24064 <
> ffff88003ac37e40 992179003 S Bi:2:013:1 -115 24064 <
> ffff88003ac37240 992190198 C Bi:2:013:1 0 24064 = 471fff10 00000000
> 00000000 00000000 00000000 00000000 00000000 00000000
> ffff88000601f480 992194368 S Bi:2:013:1 -115 24064 <
> ffff88003ac37000 992203209 C Bi:2:013:1 0 24064 = 4701b114 43867ee6
> 40790660 e898681c 9b1c7dca 08980d43 73181369 9be1bc67
> ffff880067e38a80 992204642 S Bi:2:013:1 -115 24064 <
> ffff88003ac37c00 992216318 C Bi:2:013:1 0 24064 = 4740001c 0000b01d
> 0305d500 000000e0 104015e1 504016e1 60401be1 b04022e2
> ffff880067e383c0 992219978 S Bi:2:013:1 -115 24064 <
> ffff88003ac37e40 992229340 C Bi:2:013:1 0 24064 = 471fff10 00000000
> 00000000 00000000 00000000 00000000 00000000 00000000
> 
> everything starts nicely with 0x47

This is very interesting.  There are only two things that could be
happening: Either the device sends different data during the two tests,
or there's a bug in the kernel.

Now, it is possible the device is sending bad data.  The initial parts
of the two logs do not agree exactly; there are numerous small
differences in the control data sent by the device and by the program.  
I don't know whether they are significant, but if they aren't, there's
no reason for the device to send different bulk data.  The transfer
size certainly cannot account for it.  Indeed, even if the transfer
size were only 512 bytes, the first data packet should still be the 
same.

You said you don't want to spend any more time working on this problem.  
But I'd still like to track it down.  Is it possible for you to loan me 
a device for testing?  I've got a USB bus analyzer, which could help to 
pin down what's going wrong.

Alan Stern

