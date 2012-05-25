Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab2EYNAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:00:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:17103 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab2EYNAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:00:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="148381084"
Message-ID: <4FBF826B.1040101@intel.com>
Date: Fri, 25 May 2012 21:00:27 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Matthew Garrett <mjg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lantianyu1986@gmail.com
Subject: Re: USB device PM oddity in 3.5
References: <20120524203655.GK1143@zod.bos.redhat.com> <Pine.LNX.4.44L0.1205241646080.1186-100000@iolanthe.rowland.org> <20120525113936.GA23824@zod.bos.redhat.com>
In-Reply-To: <20120525113936.GA23824@zod.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/5/25 19:39, Josh Boyer wrote:
> On Thu, May 24, 2012 at 04:48:26PM -0400, Alan Stern wrote:
>> On Thu, 24 May 2012, Josh Boyer wrote:
>>
>>> I'm testing Linus' tree as the merge window happens, and I've hit an
>>> issue with what I believe is USB device power management (or something)
>>> that is causing my mouse and keyboard to become unresponsive.  After a
>>> very short time of non-use, either device will cut out.  I can move the
>>> mouse around but it doesn't relay to the screen and I noticed this is
>>> because the laser is turned off.  If I click a button on it, it will
>>> turn back on and function again until a small period of non-use.  The
>>> keyboard exhibits similar behavior, "ignoring" the first few key strokes
>>> until it wakes back up.
>>>
>>> I found this thread:
>>>
>>> http://thread.gmane.org/gmane.linux.usb.general/64292
>>> and
>>> http://marc.info/?t=133552726500001&r=1&w=2
>>>
>>> which have similar symptoms, but the kernels I'm using have the
>>> subsequent patches applied.  I'm doing a git bisect at the moment, with
>>> 72c04af as the starting good commit and 61011677 as the first bad.  I'll
>>> let you know what comes of this, but I thought I'd mail about it now in
>>> case anyone has any ideas.
>>
>> It sounds like you have autosuspend enabled on the mouse and keyboard,
>> and they don't work very well with it.  Setting the sysfs power/control
>> attributes for the two devices to "on" will prevent autosuspend.
>>
>> I don't know why this would have started happening after a kernel
>> upgrade.  Those settings are normally controlled by userspace apps.
>> Let us know what you find.
>
> OK, the bisect turned up this as the first bad commit:
>
> 54d3f8c63d6940966217b807972778fb17c3fa82 is the first bad commit
> commit 54d3f8c63d6940966217b807972778fb17c3fa82
> Author: Matthew Garrett<mjg@redhat.com>
> Date:   Fri May 11 16:08:28 2012 +0800
>
>      usb: Set device removable state based on ACPI USB data
>
>      ACPI offers two methods that allow us to infer whether or not a USB port
>      is removable. The _PLD method gives us information on whether the port is
>      "user visible" or not. If that's not present then we can fall back to the
>      _UPC method which tells us whether or not a port is connectable.
>
>      Signed-off-by: Matthew Garrett<mjg@redhat.com>
>      Signed-off-by: Lan Tianyu<tianyu.lan@intel.com>
>      Signed-off-by: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
>
> :040000 040000 d0845dc1e64bafbdc069d80edf1b43958e091b25 6cc92b4dd1f957d91572bbc60ebbff20e325d52f M	drivers
>
> At this point I'm not really sure what I should be poking at to figure
> out what/how the power is getting turned off to the keyboard and mouse.
> I can provide acpidump output, etc.  Let me know what to check for and
> I'll happily dig more.
hi josh:
	Have you cat power/runtime_status and control under usb device sys 
directory when the issue happen? We can determine which state the usb 
device is in when the issue is takeing place.

>
> josh


-- 
Best Regards
Tianyu Lan
linux kernel enabling team
