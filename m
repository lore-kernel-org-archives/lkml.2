Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab0IBRL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:11:28 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:40511 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964Ab0IBRL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:11:27 -0400
Message-ID: <4C7FDABA.7080307@simon.arlott.org.uk>
Date: Thu, 02 Sep 2010 18:11:22 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100605 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: output an error message when the pipe type  doesn't
 match the endpoint type
References: <Pine.LNX.4.44L0.1009021019090.1513-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009021019090.1513-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/10 15:22, Alan Stern wrote:
> On Thu, 2 Sep 2010, Simon Arlott wrote:
> 
>> On Wed, September 1, 2010 18:49, Alan Stern wrote:
>> > On Wed, 1 Sep 2010, Simon Arlott wrote:
>> >> > This is okay with me.  If you're serious about not changing the
>> >> > behavior merely because debugging is enabled, you could move this test
>> >> > out of the debug-only region and possibly change the dev_err to
>> >> > dev_dbg.  However doing so might break some devices that are currently
>> >> > working.
> 
> Which suggests that the best approach is to print the error message 
> always, but allow the submission unless CONFIG_USB_DEBUG is set.

That could result in a lot of error messages, and it doesn't give any
information on which driver caused it, but a single WARN_ON() would
only be triggered once globally. Each USB device (or endpoint) could
have a "warned" flag.

>> Looking at usb_clear_halt(), it doesn't use the direction either... but
>> drivers can call it in both directions. Several drivers already do this.
> 
> What do you mean?  Look at the first lines of code in usb_clear_halt():
> 
> 	if (usb_pipein(pipe))
> 		endp |= USB_DIR_IN;

Sorry, I misread it as always selecting the same direction.

-- 
Simon Arlott
