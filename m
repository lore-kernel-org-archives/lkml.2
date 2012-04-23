Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2DWW4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:56:09 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:62689 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab2DWW4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:56:08 -0400
Date: Mon, 23 Apr 2012 15:56:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: George Nychis <gnychis@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: what determines how firmware is loaded? (Q. on request_firmware
 details)
Message-ID: <20120423225603.GA23276@kroah.com>
References: <CA+7oygfcQbOFdCFibTW0pqYQpcLwrqCM_jvKpr=GYFBMn9t3GQ@mail.gmail.com>
 <20120423212144.GA3378@kroah.com>
 <CA+7oygc839sn-s3hHo0XBA_BJop86hZB1h987af1caJ6pAOwyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+7oygc839sn-s3hHo0XBA_BJop86hZB1h987af1caJ6pAOwyw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 05:28:51PM -0400, George Nychis wrote:
> Hi Greg,
> 
> On Mon, Apr 23, 2012 at 5:21 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Apr 23, 2012 at 04:18:56PM -0400, George Nychis wrote:
> >> Hi all,
> >>
> >> I notice in an older version of Ubuntu that when I plugin a USB
> >> wireless device its firmware is loaded via sysfs.  For example, this
> >> would pop up in sysfs:
> >> /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-1/compat_firmware/2-1/loading
> >
> > How old are we talking about here?  What version of the kernel?
> 
> This was on a 2.6.32-21 Kernel.  Ubuntu 10.04 LTS.
> 
> >
> >> Has the former method of loading firmware been removed as the default?
> >>  Is there any way to request that the firmware load be done manually
> >> (the former method)?
> >
> > Why?  In the end, they do the same thing, right?
> 
> I am having issues with the automatic load on an embedded device
> running a 3.0.8 kernel.  I get USB URB related errors like this:
> <7>[  708.739241] ath9k_htc 1-1.1:1.0: usb_probe_interface - got id
> <3>[  708.999596] otg_err: in s5pc110_otghcd_urb_dequeue()::00508
> <3>[  709.000670] => fail to cancel_transfer()
> <7>[  709.002489] usb 1-1.1: hcd_unlink_urb d2f7c780 fail -1
> <7>[  709.004372] usb 1-1.1: khubd timed out on ep0out len=0/4096
> <3>[  709.005181] usb 1-1.1: ath9k_htc: Firmware - htc_7010.fw download failed

You do realize just how old and obsolete your 3.0.8 kernel is, right?  I
suggest you update to the latest version, or, if you are stuck with this
kernel, go ask the vendor who provided it to you for support, as they
are the best ones to help you out.

Either way, it looks like this is a USB issue in your usb controller,
not a firmware issue, so I don't think the firmware portion of the
interaction is the problem.

best of luck,

greg k-h
