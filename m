Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab2EYFsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 01:48:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41266 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2EYFsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 01:48:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120524215249.GA17936@kroah.com>
References: <20120426001529.GA14006@kroah.com>
	<Pine.LNX.4.44L0.1204261103120.1530-100000@iolanthe.rowland.org>
	<20120426151242.GA14774@kroah.com>
	<CAAJw_Zug=xFjzaguqfq+-HYBjmwDPJ+5Ntj=otMY4MJk2UWxDQ@mail.gmail.com>
	<20120524215249.GA17936@kroah.com>
Date: Fri, 25 May 2012 13:48:06 +0800
Message-ID: <CAAJw_ZtaeAV2nZU7LcyngJTN15YVn+8y2dMPxtBqTGn750Tjdg@mail.gmail.com>
Subject: Re: [RFC PATCH] USB: remove CONFIG_USB_DEVICEFS
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 5:52 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, May 24, 2012 at 11:55:16PM +0800, Jeff Chua wrote:
>> On Thu, Apr 26, 2012 at 11:12 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Thu, Apr 26, 2012 at 11:06:45AM -0400, Alan Stern wrote:
>> >> On Wed, 25 Apr 2012, Greg Kroah-Hartman wrote:
>> >>
>> >> > This option has been deprecated for many years now, and no userspace
>> >> > tools use it anymore, so it should be safe to finally remove it.
>> >> >
>> >> > Reported-by: Kay Sievers <kay@vrfy.org>
>> >> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> >> >
>> >> > Anyone object to me queuing this up for the 3.5 kernel release?
>> >>
>> >> I'm not sure about this.  There are a few systems still floating around
>> >> that don't use udev; on those systems /proc/bus/usb is the only way for
>> >> user programs to control USB devices.  Admittedly, I have no idea
>> >> whether any such systems will be using 3.5 or later kernels...
>> >
>> > They don't have to use udev, they can use devtmpfs (which is what the
>> > majority of embedded systems use today), or they can just use static
>> > device nodes to get access to these devices, the char node is still
>> > present, we aren't getting rid of them at all.
>>
>> Looks like vmware is breaking. Can't find any usb devices. I'm not using udev.
>
> vmware doesn't use usbfs, otherwise how would it be working on all of
> the systems out there that haven't mounted usbfs for years?
>
> What exactly broke?  What version of vmware are you using, and is the
> problem in the guest or host?
>
> We delayed other usbfs changes for years due to vmware "issues", it
> wouldn't be the first time we've had to handle this :(


VMWare workstation 8.0.3

# vmware-usbarbitrator -f --info
DICT       product.buildNumber = 703057
DICT           product.version = 8.0.3
DICT workstation.product.version = 8.0.3
DICT              product.name = VMware Workstation
VMware USB Arbitration Service Version 8.4.19
USB: Unable to open "/proc/bus/usb/devices" (No such file or directory).
No USB enumerator!

If I revert back to git pull 3 years earlier, it works.

Thanks,
Jeff
