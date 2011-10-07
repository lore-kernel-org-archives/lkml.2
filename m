Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583Ab1JGFJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 01:09:50 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41733 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1JGFJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 01:09:47 -0400
MIME-Version: 1.0
In-Reply-To: <1317845295.7238.15.camel@dabdike>
References: <CADDb1s0ZnHzM72sDnFmRrM=GFJtxj5JkYUSPo6GdyQ_=7L2m9A@mail.gmail.com>
	<Pine.LNX.4.44L0.1110041007070.1954-100000@iolanthe.rowland.org>
	<CADDb1s0taBR2=xpKE5rLJTWJBMbXijS8b_GEA-MbZvWKFDFvYg@mail.gmail.com>
	<CADDb1s3sPxpfNi-OD=QvVT+JWO9kUeTAmb8ZGyN0YCuBKWd4rg@mail.gmail.com>
	<CADDb1s3FN4Ft2yXs-L8LfhoJEDP+KhSCrG8GGbOUgn_GXEr0yA@mail.gmail.com>
	<1317835442.7238.8.camel@dabdike>
	<CADDb1s031VX65+G-Uq-12y4qWq98-OS6DKz7mUCo=8AQkVQVTQ@mail.gmail.com>
	<1317845295.7238.15.camel@dabdike>
Date: Fri, 7 Oct 2011 10:39:45 +0530
Message-ID: <CADDb1s3524xiQfde3tiub=QvkrRH0yo8vsurSn2ewMQJe2oktw@mail.gmail.com>
Subject: =?windows-1252?Q?Re=3A_Re=3A_Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD?=
	=?windows-1252?Q?=92s_in_scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5F?=
	=?windows-1252?Q?type=29?=
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to set the cache type as "write back" through "echo "write
back" > /sys/class/scsi_disk/<disk>/cache_type" does not work.
Few logs :
#> usb 2-1.4: new high speed USB device using ehci-sdp and address 5
usb 2-1.4: New USB device found, idVendor=152d, idProduct=2339
usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=5
usb 2-1.4: Product: USB to ATA/ATAPI Bridge
usb 2-1.4: Manufacturer: JMicron
usb 2-1.4: SerialNumber: 3446184AA01C
scsi1 : usb-storage 2-1.4:1.0
scsi 1:0:0:0: Direct-Access     SAMSUNG  HM501IX               PQ: 0 ANSI: 2 CCS
sd 1:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
 sda:

#> echo "write back" > /sys/class/scsi_disk/1\:0\:0\:0/cache_type
sd 1:0:0:0: [sda] Sense Key : 0x5 [current]
sd 1:0:0:0: [sda] ASC=0x20 ASCQ=0x0


#> usb 2-1.4: new high speed USB device using ehci-sdp and address 4
usb 2-1.4: New USB device found, idVendor=0bc2, idProduct=2300
usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1.4: Product: Portable
usb 2-1.4: Manufacturer: Seagate
usb 2-1.4: SerialNumber: 2GHW02GR
scsi0 : usb-storage 2-1.4:1.0

#>
#> scsi 0:0:0:0: Direct-Access     Seagate  Portable         0130 PQ: 0 ANSI: 4
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] No Caching mode page present
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] No Caching mode page present
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] No Caching mode page present
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] Attached SCSI disk

#> echo "write back" > /sys/class/scsi_disk/0\:0\:0\:0/cache_type
sd 0:0:0:0: [sda] No Caching mode page present
sd 0:0:0:0: [sda] Assuming drive cache: write through
#>


#> usb 2-1.4: new high speed USB device using ehci-sdp and address 7
usb 2-1.4: New USB device found, idVendor=1058, idProduct=070a
usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1.4: Product: My Passport 070A
usb 2-1.4: Manufacturer: Western Digital
usb 2-1.4: SerialNumber: 575832314132304534373635
scsi3 : usb-storage 2-1.4:1.0
scsi 3:0:0:0: Direct-Access     WD       My Passport 070A 1032 PQ: 0 ANSI: 4
scsi 3:0:0:1: CD-ROM            WD       Virtual CD 070A  1032 PQ: 0 ANSI: 4
scsi 3:0:0:2: Enclosure         WD       SES Device       1032 PQ: 0 ANSI: 4
sd 3:0:0:0: [sda] 623769600 512-byte logical blocks: (319 GB/297 GiB)
sd 3:0:0:0: [sda] Write Protect is off
sd 3:0:0:0: [sda] No Caching mode page present
sd 3:0:0:0: [sda] Assuming drive cache: write through
sd 3:0:0:0: [sda] No Caching mode page present
sd 3:0:0:0: [sda] Assuming drive cache: write through
 sda:
sd 3:0:0:0: [sda] No Caching mode page present
sd 3:0:0:0: [sda] Assuming drive cache: write through
sd 3:0:0:0: [sda] Attached SCSI disk

#> cat /sys/class/scsi_disk/3\:0\:0\:0/cache_type
write through
#> echo "write back" > /sys/class/scsi_disk/3\:0\:0\:0/cache_type
#>
#> echo "write back" > /sys/class/scsi_disk/3\:0\:0\:0/cache_type
#>
#>
#> cat /sys/class/scsi_disk/3\:0\:0\:0/cache_type
write through

Regards,
Amit Sahrawat

On Thu, Oct 6, 2011 at 1:38 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2011-10-06 at 01:21 +0530, Amit Sahrawat wrote:
>> > The best we could probably offer is an interface to turn on the WCE bit
>> > in software (technically, you can do this today
>> > in /scsi/class/scsi_disk/<disk>/cache_type, it's just that it will try
>> > to commit the change as a MODE_SELECT which will presumably fail).
>> Thanks James, is this related with SCSI command MODE_SELECT? and this
>> is to be passed when there is some failure?
>> or simply doing an "echo <value>" to
>> /scsi/class/scsi_disk/<disk>/cache_type? can you please elaborate a
>> little
>
> You tell me since you have the device.  What that echo does is that it
> does try to make the change permanent with a mode select ... that likely
> won't work and the cache change only takes if the revalidated disk says
> the write back has been enabled (which I really think it won't).  So I
> think you need an additional software bit to flip for the case where the
> device lies.
>
> James
>
>
>
