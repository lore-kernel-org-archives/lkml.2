Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2AaSXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 13:23:15 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33511 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2AaSXO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 13:23:14 -0500
MIME-Version: 1.0
In-Reply-To: <CADY4qd+d=_nYkFq86QyfcC8JxgK17F9foN3UZS-iLYKR=t2-BA@mail.gmail.com>
References: <CADY4qd+d=_nYkFq86QyfcC8JxgK17F9foN3UZS-iLYKR=t2-BA@mail.gmail.com>
From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Date: Tue, 31 Jan 2012 10:22:53 -0800
Message-ID: <CAA6KcBB95Egv5nv=ew_pO9wXDN8zE3Sp0aATGQ7-nNz4eRfwNw@mail.gmail.com>
Subject: Re: USB storage quirk
To: Russell Strong <russell@strong.id.au>
Cc: linux-kernel@vger.kernel.org,
        USB Mass Storage on Linux 
	<usb-storage@lists.one-eyed-alien.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'rw' sets the flags to "ignore residue" and "skip write-protect
checking".  Are both flags really needed?

Matt

On Tue, Jan 31, 2012 at 2:44 AM, Russell Strong <russell@strong.id.au> wrote:
> Hi Matthew,
>
> I pulled you name from the kernel maintainers file to let someone know
> about a quirk that I discovered with an MP3 player that connects as
> usb-storage.  Hope I've got this right.
>
> When I connected it to my fedora 8/14/16 machine ( sorry not the
> latest kernel ) it didn't work.  The following is the dmesg output:
>
> [ 1703.287204] usb 2-1: new high speed USB device using ehci_hcd and address 4
> [ 1703.402018] usb 2-1: New USB device found, idVendor=1e74, idProduct=4641
> [ 1703.402025] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [ 1703.402030] usb 2-1: Product: USB
> [ 1703.402034] usb 2-1: Manufacturer:
> [ 1703.402037] usb 2-1: SerialNumber: USBV1.00
> [ 1703.402840] scsi5 : usb-storage 2-1:1.0
> [ 1704.403915] scsi 5:0:0:0: Direct-Access              USB DISK
>   1.00 PQ: 0 ANSI: 0
> [ 1704.409525] sd 5:0:0:0: Attached scsi generic sg3 type 0
> [ 1704.411604] sd 5:0:0:0: [sdc] 15958016 512-byte logical blocks:
> (8.17 GB/7.60 GiB)
> [ 1704.514300] usb 2-1: reset high speed USB device using ehci_hcd and address 4
> [ 1709.628307] usb 2-1: device descriptor read/all, error -110
> [ 1709.730154] usb 2-1: reset high speed USB device using ehci_hcd and address 4
> ....
>
> So I played around with the usb-storage parameter quirks, and found
> that 1e74:4641:rw worked a treat.  Hope this is helpful.
>
> For all the others googling for this :
> Dick Smith Electronics MP3 player 8GB
> DSE
> A8705
> add kernel command line parameter usb-storage.quirks=1e74:4641:rw
>
> Regards,
> Russell



-- 
Matthew Dharm
Maintainer, USB Mass Storage driver for Linux
