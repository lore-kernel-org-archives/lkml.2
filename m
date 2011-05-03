Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab1ECJkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 05:40:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36753 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab1ECJkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 05:40:32 -0400
Message-ID: <4DBFCD88.6020900@sieker.io>
Date: Tue, 03 May 2011 11:40:24 +0200
From: "Adi J. Sieker" <adi@core.adi.io>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oliver@neukum.org>,
        USB list <linux-usb@vger.kernel.org>, linux-input@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: USB keyboard recognized as HID keyboard but doesn't work
References: <Pine.LNX.4.44L0.1105021826040.8810-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1105021826040.8810-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/11 00:29, Alan Stern wrote:
> On Mon, 2 May 2011, Adi J. Sieker wrote:
>
>>> Interestingly, the usbmon trace shows that the interrupt endpoint for
>>> interface 1 isn't being used by usbhid.  I don't know why, but it
>>> shouldn't make much difference for your purposes since that interface
>>> appears to be associated with the gaming interface.  But maybe I'm
>>> wrong and it is important somehow...
>>>
>>> The other noticeable thing is that the keyboard didn't accept the
>>> Set-Idle request for interface 1.
>>>
>>> You said before that the keyboard worked okay when driven by a guest
>>> Windows OS, right?  Can you collect an equivalent usbmon trace for
>>> that?  Comparing the two traces may be instructive.
>>
>> I hope this is what you meant. :)
>> Attached is a usbmon trace when I attach the keyboard to a VBox VM
>> running a Windows XP guest. I have no idea how to get a USB trace from
>> within Windows. The last block is when I pressed h twice in the Windows
>> XP guest.
>
> This is perfect.  It shows that the H key is reported using the
> interrupt endpoint on interface 1, which explains why it's not working
> with usbhid.  It also shows that the rejected Set-Idle request doesn't
> matter.
>
Do you know of a way for me to tell the kernel/usbhid to use interface 1 
and ignore interface 0?

Thanks
    Adi
