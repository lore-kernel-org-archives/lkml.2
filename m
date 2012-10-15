Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab2JOTVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 15:21:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51025 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab2JOTVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 15:21:02 -0400
MIME-Version: 1.0
In-Reply-To: <20121015181807.GA27923@kroah.com>
References: <CAAt=GnLTAxyHvYO39+FCc2MRR+daHOqKofmfTkH_8N4ZRs8s_Q@mail.gmail.com>
	<20121015181126.GA27779@kroah.com>
	<20121015181807.GA27923@kroah.com>
Date: Mon, 15 Oct 2012 15:21:01 -0400
Message-ID: <CAAt=GnJZmPCqjgP3-XNLwf=+OTvEm2KKpGP1ON1JQ+=KCziCPQ@mail.gmail.com>
Subject: Re: usbserial & ftdi_sio problem
From: Mostafa Kassem <m.kassem681@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the prompt reply, please see inline.

On Mon, Oct 15, 2012 at 2:18 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Oct 15, 2012 at 11:11:26AM -0700, Greg KH wrote:
>> On Mon, Oct 15, 2012 at 01:15:05PM -0400, Mostafa Kassem wrote:
>> > Greetings,
>> >
>> > I am having a problem with usbserial and ftdi_sio kernel loadable modules.
>> >
>> > I am working on an embedded board using RHEL 6.0.
>>
>> Wait right there.  If you are using RHEL, you need to get support from
>> Red Hat for it, especially as you are already paying for it, you should
>> use it.

Thanks, will do.

>> > The board has 2 FTDI
>> > chips each with quad serial interface for a total of 8 serial ports.
>> > In addition, we have a WiFi module that behaves as a USB to Serial
>> > converter.
>>
>> What specific wifi module is this?  What driver is it?

The FTDI chips are FT4232 and the WiFi module is from connectone, this
one: http://www.connectone.com/?page_id=233

>> > I can see in /dev directory that the 8 serial ports from FTDI are
>> > mapped as ttyUSB0 to ttyUSB7, however I can't find the WiFi module. If
>> > I disable the loading of ftdi_sio.ko module, the WiFi module appears
>> > as ttyUSB0 and it works fine. It seems to me that both the WiFi module
>> > and the one of the FTDI interfaces want to use ttyUSB0 and it seems
>> > that the FTDI interface is winning.
>>
>> Odd, again, what driver/device is this wifi device?

Please see above.

>>
>> > Even if I rename the FTDI interfaces from ttyUSB0..7 to fdtisio0..7 ,
>> > I still don't see the WiFi module.
>> >
>> > The WiFi module is loaded in rc.local  using modprobe usbserial
>> > vendor=0x**** product=0x**** as per the WiFi module vendor's
>> > recommendations.
>>
>> Oh, that's the problem, NEVER do that, you just broke things, as you
>> found out.  No one should ever use the generic usb serial interface,
>> newer kernels will warn you about this.  Let the proper driver manage
>> the wifi device and you will not have any of these issues.
>

Well, I had to do that or the WiFi device won't work, as simple as
that. It is also what the manufacturer recommends. The manufacturer is
using the generic usbserial and don't have a specific driver.

> Also, what is the vendor and product id you are passing to the driver?
> That will help us determine what the real driver you should be using
> instead.
>

vendor=0x1af1 and product=0x0003

> thanks,
>
> greg k-h

No, thank you. Your help is greatly appreciated.

Mostafa
