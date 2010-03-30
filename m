Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab0C3MWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:22:00 -0400
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:60819 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab0C3MV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:21:59 -0400
Message-ID: <4BB1ECE4.5070606@shikadi.net>
Date: Tue, 30 Mar 2010 22:21:56 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.23) Gecko/20091130 Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: usbhid: How to wait for response after submitting report
References: <4B9B022F.6060402@shikadi.net> <alpine.LNX.2.00.1003151706330.18642@pobox.suse.cz> <4BADF177.1070201@shikadi.net> <alpine.LNX.2.00.1003301407320.24576@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1003301407320.24576@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Basically I have a USB HID device, and it works by submitting a HID report,
>> then waiting until it replies with (I assume) another HID report.  The
>> messages are all proprietary.  I can send the reports fine, but half the time
>> I get garbage coming back, which I assume is because I'm not getting the
>> message quickly enough and processing whatever was in the buffer instead.
>>
>> If you're able to point me in the direction of an example showing how to set
>> up and use a completion handler, hopefully I can change my code to work like
>> that instead.
> 
> Well this is rather more USB-related question than HID related question, 
> I'd say.

Well originally I was going to write a USB driver, but as it's a HID device
and there's a HID class in the kernel, I thought it would be better to use the
functions provided by the USB HID device class.

> Basically you prepare URB, along with specifying which routine should be 
> called by USB core as completion handler, and then submit the URB.

Can I do this without conflicting with the HID "layer"?  I assumed that
drivers appearing in the HID class should only use HID functions, and those
functions would take care of the USB side of things.  I don't really want to
reimplement all the standard HID communication code when it has already been
implemented in the USB HID driver/class.

> USB HID implementation is working like this (and zillions of other USB 
> drivers which are in kernel do as well) -- just look at initialization of 
> control URB in usbhid_start(), and the completion handler (for control 
> URBs) in hid_ctrl().

At the moment I am calling functions like hid_hw_start and
usbhid_submit_report, which (I think) take care of all this for me.  There's
not a lot of documentation about how the HID class works, and only a handful
of drivers unfortunately, since it's a standard USB device class - you only
need to write a driver for nonstandard hardware, which means all the existing
HID drivers are all very different!

Because usbhid_submit_report takes the raw data to be packaged up inside a USB
HID message, I don't have an opportunity to set any sort of completion
handler.  I imagine the HID class takes care of it, but I don't know how to
figure out whether the completion handler has been called and there's data to
read.

Thanks,
Adam.
