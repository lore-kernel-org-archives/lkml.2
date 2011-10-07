Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965425Ab1JGOJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 10:09:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34677 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759968Ab1JGOJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 10:09:50 -0400
Date: Fri, 7 Oct 2011 10:09:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Douglas Gilbert <dgilbert@interlog.com>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: =?windows-1252?Q?Re=3A_Re=3A_Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD?=
 =?windows-1252?Q?=92s_in_scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5F?=
 =?windows-1252?Q?type=29
In-Reply-To: <CADDb1s3524xiQfde3tiub=QvkrRH0yo8vsurSn2ewMQJe2oktw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1110071005170.1930-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Oct 2011, Amit Sahrawat wrote:

> Trying to set the cache type as "write back" through "echo "write
> back" > /sys/class/scsi_disk/<disk>/cache_type" does not work.
> Few logs :
> #> usb 2-1.4: new high speed USB device using ehci-sdp and address 5
> usb 2-1.4: New USB device found, idVendor=152d, idProduct=2339
> usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=5
> usb 2-1.4: Product: USB to ATA/ATAPI Bridge
> usb 2-1.4: Manufacturer: JMicron
> usb 2-1.4: SerialNumber: 3446184AA01C
> scsi1 : usb-storage 2-1.4:1.0
> scsi 1:0:0:0: Direct-Access     SAMSUNG  HM501IX               PQ: 0 ANSI: 2 CCS
> sd 1:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> sd 1:0:0:0: [sda] Write Protect is off
> sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't
> support DPO or FUA
>  sda:
> 
> #> echo "write back" > /sys/class/scsi_disk/1\:0\:0\:0/cache_type
> sd 1:0:0:0: [sda] Sense Key : 0x5 [current]
> sd 1:0:0:0: [sda] ASC=0x20 ASCQ=0x0

This is what James was talking about.  When you write something to 
/sys/class/scsi_disk/.../cache_type, the value you specify is sent to 
the drive using a MODE SELECT command.  However, if a USB drive doesn't 
report the caching type properly, it's not very likely to support the 
appropriate MODE SELECT command either.

What you need to do is create a variant of the cache_type sysfs 
attribute, one that will set or clear the WCE flag directly, without 
trying to communicate with the drive.

Alan Stern

