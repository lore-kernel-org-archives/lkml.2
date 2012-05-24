Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965454Ab2EXVw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:52:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53033 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965209Ab2EXVw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:52:57 -0400
Date: Fri, 25 May 2012 06:52:49 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] USB: remove CONFIG_USB_DEVICEFS
Message-ID: <20120524215249.GA17936@kroah.com>
References: <20120426001529.GA14006@kroah.com>
 <Pine.LNX.4.44L0.1204261103120.1530-100000@iolanthe.rowland.org>
 <20120426151242.GA14774@kroah.com>
 <CAAJw_Zug=xFjzaguqfq+-HYBjmwDPJ+5Ntj=otMY4MJk2UWxDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAJw_Zug=xFjzaguqfq+-HYBjmwDPJ+5Ntj=otMY4MJk2UWxDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:55:16PM +0800, Jeff Chua wrote:
> On Thu, Apr 26, 2012 at 11:12 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Apr 26, 2012 at 11:06:45AM -0400, Alan Stern wrote:
> >> On Wed, 25 Apr 2012, Greg Kroah-Hartman wrote:
> >>
> >> > This option has been deprecated for many years now, and no userspace
> >> > tools use it anymore, so it should be safe to finally remove it.
> >> >
> >> > Reported-by: Kay Sievers <kay@vrfy.org>
> >> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> >
> >> > Anyone object to me queuing this up for the 3.5 kernel release?
> >>
> >> I'm not sure about this.  There are a few systems still floating around
> >> that don't use udev; on those systems /proc/bus/usb is the only way for
> >> user programs to control USB devices.  Admittedly, I have no idea
> >> whether any such systems will be using 3.5 or later kernels...
> >
> > They don't have to use udev, they can use devtmpfs (which is what the
> > majority of embedded systems use today), or they can just use static
> > device nodes to get access to these devices, the char node is still
> > present, we aren't getting rid of them at all.
> 
> Looks like vmware is breaking. Can't find any usb devices. I'm not using udev.

vmware doesn't use usbfs, otherwise how would it be working on all of
the systems out there that haven't mounted usbfs for years?

What exactly broke?  What version of vmware are you using, and is the
problem in the guest or host?

We delayed other usbfs changes for years due to vmware "issues", it
wouldn't be the first time we've had to handle this :(

thanks,

greg k-h
