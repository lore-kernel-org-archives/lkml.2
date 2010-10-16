Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0JPUfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 16:35:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48253 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab0JPUfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 16:35:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CBA0C8C.6050909@s5r6.in-berlin.de>
Date: Sat, 16 Oct 2010 22:35:24 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: David Brownell <david-b@pacbell.net>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36-rc7: NULL pointer dereference in ehci_clear_tt_buffer_complete
References: <Pine.LNX.4.44L0.1010161600240.21391-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1010161600240.21391-100000@netrider.rowland.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Sat, 16 Oct 2010, Stefan Richter wrote:
>> Alan Stern wrote:
>>> --- usb-2.6.orig/drivers/usb/core/message.c
>>> +++ usb-2.6/drivers/usb/core/message.c
>>> @@ -323,8 +323,13 @@ static void sg_complete(struct urb *urb)
>>>  	/* on the last completion, signal usb_sg_wait() */
>>>  	io->bytes += urb->actual_length;
>>>  	io->count--;
>>> -	if (!io->count)
>>> +	if (!io->count) {
>>> +		if (status == -ECONNRESET) {
>>> +			printk(KERN_ERR "Delaying for test\n");
>>> +			mdelay(600);
>>> +		}
>>>  		complete(&io->complete);
>>> +	}
>>>  
>>>  	spin_unlock(&io->lock);
>>>  }
>>>
>> I did so today on 2.6.36-rc8, without your other patch.  I was still unable to
>> reproduce the bug.  Forget the whole thing as unreproducible?
> 
> What I said above wasn't quite right.  This won't help trigger the 
> oops, but it should trigger the line saying something like
> 
> 	ehci_hcd 0000:00:12.2: qh ffff880208f07af0 (#00) state 5
> 
> That's the real bug.

# grep ' qh ' /var/log/messages
Oct 11 22:29:21 stein kernel: ehci_hcd 0000:00:12.2: qh ffff880208f07af0 (#00)
state 5

I.e. there was none anymore since the one which I reported on Monday.
-- 
Stefan Richter
-=====-==-=- =-=- =----
http://arcgraph.de/sr/
