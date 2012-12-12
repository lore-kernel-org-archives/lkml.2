Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab2LLPlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 10:41:51 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39523 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754253Ab2LLPlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 10:41:50 -0500
Date: Wed, 12 Dec 2012 10:41:49 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Robert Hancock <hancockrwd@gmail.com>
cc: prasannatsmkumar <prasannatsmkumar@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <nautilus-list@gnome.org>
Subject: Re: Fwd: Safely remove option shows with Micro SD Card connected to
 Linux through an Android phone
In-Reply-To: <50C823A5.3050904@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1212121040000.1488-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2012, Robert Hancock wrote:

> On 12/11/2012 02:37 PM, Alan Stern wrote:
> > On Tue, 11 Dec 2012, prasannatsmkumar wrote:
> >
> >> Hi All,
> >>
> >> I connected an Android phone using USB cable to my machine running
> >> Linux (Linux 3.0, 3.2, 3.5). Mounted the SD card in phone in system
> >> (phone is just a pass through I guess). When I choose "Safely Remove"
> >> option in nautilus file manager (gnome's default file manager) I got
> >> an error saying
> >>
> >> "Error detaching: helper exited with exit code 1: Detaching device /dev/sdb
> >> USB device: /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-5)
> >> SYNCHRONIZE CACHE: OK
> >> STOP UNIT: FAILED: No such file or directory"
> >
> > STOP UNIT means spin down the disk or eject the disc.  Since your phone
> > doesn't have a disk drive or an optical disc, no wonder this step
> > failed.
> 
> The reason it's likely doing a STOP UNIT on USB storage devices is that 
> this is preferable for at least USB-connected HDs (at least where the 
> USB to SATA, etc. converter bothers to implement the translation). For 
> many drives, it's better for the disk's lifespan to power it down 
> normally (as it would be if it was in a machine that was being shut 
> down) so it can unload its heads in a controlled fashion, rather than 
> just cutting the power on the running disk and causing an emergency head 
> retract.
> 
> Some types of devices may not support that command or may not do 
> anything useful with it, but "No such file or directory" seems a strange 
> error to run into.

That's the error code returned by the USB stack when a request is 
cancelled synchronously.  But it is intended for internal kernel use 
only; it should not appear at the userspace level.  Without knowing the 
details of what the program did, it's hard to tell how that code got 
there.

Alan Stern

