Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab2EYLfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 07:35:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53677 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab2EYLfR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 07:35:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP10bzpJ1vEX9SqddV2qr9AuNY-fgZN444S-pYNM21ByBOA@mail.gmail.com>
References: <20120426001529.GA14006@kroah.com> <Pine.LNX.4.44L0.1204261103120.1530-100000@iolanthe.rowland.org>
 <20120426151242.GA14774@kroah.com> <CAAJw_Zug=xFjzaguqfq+-HYBjmwDPJ+5Ntj=otMY4MJk2UWxDQ@mail.gmail.com>
 <20120524215249.GA17936@kroah.com> <CAAJw_ZtaeAV2nZU7LcyngJTN15YVn+8y2dMPxtBqTGn750Tjdg@mail.gmail.com>
 <20120525060124.GA18035@kroah.com> <CAAJw_Ztke1NqY6Jm2fqyPOWzeVAqK=pKv=6bPhhdGaNVHaHM+g@mail.gmail.com>
 <20120525071643.GA9105@kroah.com> <CAPXgP10bzpJ1vEX9SqddV2qr9AuNY-fgZN444S-pYNM21ByBOA@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 25 May 2012 13:34:56 +0200
Message-ID: <CAPXgP10j_bj4Z_EhvLu7iZHBW5JcdFG0zf9mMt8t5t-kWmh59g@mail.gmail.com>
Subject: Re: [RFC PATCH] USB: remove CONFIG_USB_DEVICEFS
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 11:01 AM, Kay Sievers <kay@vrfy.org> wrote:
> On Fri, May 25, 2012 at 9:16 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Fri, May 25, 2012 at 03:06:33PM +0800, Jeff Chua wrote:
>
>>> >> VMware USB Arbitration Service Version 8.4.19
>>> >> USB: Unable to open "/proc/bus/usb/devices" (No such file or directory).
>
> I think vmware tries to open the usual /dev/bus/usb/ nodes directly
> after it has tried the deprecated /proc nodes.
>
> Udev would create the /dev/bus/ nodes.
>
> Or the kernel would create them itself if:
>  CONFIG_DEVTMPFS=y
>  CONFIG_DEVTMPFS_MOUNT=y
> is used.

Jeff,

if you still need to keep your static /dev setup, can you please try:
  $ mkdir /dev/bus
  $ mount -t devtmpfs none /dev/bus
  $ mount --bind /dev/bus/bus /dev/bus

This should replace the yucky usbfs nodes at /proc/bus/ with the usual
/dev/bus/ kernel-managed device nodes. It tricks the usually used /dev
devtmpfs, into just providing /dev/bus/ on top of your static /dev.

VMWare should pick up this directory, just like it works for all usual
distro-like setups, and find the dynamically managed USB devices.

Kay
