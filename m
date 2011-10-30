Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162Ab1J3PaP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 11:30:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55735 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab1J3PaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 11:30:14 -0400
Message-ID: <4EAD6D90.60905@lwfinger.net>
Date: Sun, 30 Oct 2011 10:30:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: USB list <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        v4mp <gaigo88@hotmail.it>
Subject: Re: Question about error from xhci-hcd
References: <4EAC3C5C.5000209@lwfinger.net> <20111030050443.GC4535@xanatos>
In-Reply-To: <20111030050443.GC4535@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2011 12:04 AM, Sarah Sharp wrote:
> On Sat, Oct 29, 2011 at 12:48:12PM -0500, Larry Finger wrote:
>> Sarah,
>>
>> Pardon the intrusion, but I'm trying to fix a problem for v4mp, a
>> user of the rtl8192cu driver on an Alfa AWUS036NHR. I have one of
>> the devices, and it works on a USB 2.0 hub, but fails with 3.0
>> hardware with lots of
>>
>> xhci_hcd 0000:05:00.0: ERROR no room on ep ring
>>
>> messages logged.
>
> The xHCI driver allocates a fixed-size endpoint ring, and only so much
> data can fit on it.  If the driver is allocating many URBs or many URBs
> with a lot of data, then you will see these messages and the URBs will
> fail to be submitted.  Now if neither of those conditions are true, then
> it's possible we just have a bug in the xHCI driver.
>
> There is a patchset in the works to dynamically expand the endpoint
> rings, but it's still going through revisions:
>
> http://marc.info/?l=linux-usb&m=131918645424329&w=2

Thanks for the link. I'll look into that patch set and also examine the number 
of URBs that the driver is submitting.

> It might be done for the 3.3 kernel, but until then the driver is just
> going to be broken, sorry. :(

No problem.

>> The device works with an out-of-kernel driver available from the
>> Alfa or Realtek web sites, but I want to fix rtl8192cu.
>>
>> What condition leads to the above message? The user's dmesg buffer
>> has wrapped, thus I don't see the beginning of the failure. He is
>> using a canned distro kernel, thus he cannot include any extra
>> debugging info such as a stack dump when the errors occur. As he
>> uses the compat-wireless package, I think I can incorporate a new
>> copy of xhci-hcd with it, but I have not done so yet.
>
> Which distro?  Several of the distros are based on 2.6.32, which only
> had minimal support for xHCI.  Updating just the xHCI driver with a
> more recent one isn't going to be possible with that old of a kernel,
> since later changes also touched the USB core as well.

He is running the 3.1-rc9 kernel from Ubuntu. We should have no problems 
updating xHCI. I did add it to the compat-wireless package and sent the code to 
him, but have not heard back. I will try to add the new patch series to see if 
that helps.

Thanks for your help,

Larry

