Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2DWV2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:28:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46847 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab2DWV2v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:28:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120423212144.GA3378@kroah.com>
References: <CA+7oygfcQbOFdCFibTW0pqYQpcLwrqCM_jvKpr=GYFBMn9t3GQ@mail.gmail.com>
	<20120423212144.GA3378@kroah.com>
Date: Mon, 23 Apr 2012 17:28:51 -0400
Message-ID: <CA+7oygc839sn-s3hHo0XBA_BJop86hZB1h987af1caJ6pAOwyw@mail.gmail.com>
Subject: Re: what determines how firmware is loaded? (Q. on request_firmware details)
From: George Nychis <gnychis@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, Apr 23, 2012 at 5:21 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Apr 23, 2012 at 04:18:56PM -0400, George Nychis wrote:
>> Hi all,
>>
>> I notice in an older version of Ubuntu that when I plugin a USB
>> wireless device its firmware is loaded via sysfs.  For example, this
>> would pop up in sysfs:
>> /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-1/compat_firmware/2-1/loading
>
> How old are we talking about here?  What version of the kernel?

This was on a 2.6.32-21 Kernel.  Ubuntu 10.04 LTS.

>
>> Has the former method of loading firmware been removed as the default?
>>  Is there any way to request that the firmware load be done manually
>> (the former method)?
>
> Why?  In the end, they do the same thing, right?

I am having issues with the automatic load on an embedded device
running a 3.0.8 kernel.  I get USB URB related errors like this:
<7>[  708.739241] ath9k_htc 1-1.1:1.0: usb_probe_interface - got id
<3>[  708.999596] otg_err: in s5pc110_otghcd_urb_dequeue()::00508
<3>[  709.000670] => fail to cancel_transfer()
<7>[  709.002489] usb 1-1.1: hcd_unlink_urb d2f7c780 fail -1
<7>[  709.004372] usb 1-1.1: khubd timed out on ep0out len=0/4096
<3>[  709.005181] usb 1-1.1: ath9k_htc: Firmware - htc_7010.fw download failed

So I was hoping to try the manual method of sending the firmware to
see if it is related to the automatic process, or if I'm really going
to need to debug the firmware transfer.

>
>> It seems as though instead of calling request_firmware(), I could call
>> _request_firmware() with "uevent" set to 0?  This would force for
>> former behavior?
>>
>> Does "nowait" also have to be 0?  I don't quite understand the
>> separation between uevent and nowait.
>
> I don't understand the problem here, isn't the end-result the same?
> What is wrong with newer kernels?

This is likely strictly related to the embedded device, and possibly
some bugs related to it.  But I was hoping to force manual mode to
narrow down the issue and see if that is at least a possible solution.

Thanks for the response!

- George
