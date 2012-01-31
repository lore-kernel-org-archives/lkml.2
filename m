Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab2AaWIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 17:08:12 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62853 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab2AaWIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 17:08:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAA6KcBB95Egv5nv=ew_pO9wXDN8zE3Sp0aATGQ7-nNz4eRfwNw@mail.gmail.com>
References: <CADY4qd+d=_nYkFq86QyfcC8JxgK17F9foN3UZS-iLYKR=t2-BA@mail.gmail.com>
	<CAA6KcBB95Egv5nv=ew_pO9wXDN8zE3Sp0aATGQ7-nNz4eRfwNw@mail.gmail.com>
Date: Wed, 1 Feb 2012 08:08:09 +1000
X-Google-Sender-Auth: KWT7_2kDNl5IuSBT7L9KQQRHS9g
Message-ID: <CADY4qdLn9zo87qug=9SbXCLqf46exA3HEBa3Usxxxyymiuk0Xw@mail.gmail.com>
Subject: Re: USB storage quirk
From: Russell Strong <russell@strong.id.au>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: linux-kernel@vger.kernel.org,
        USB Mass Storage on Linux 
	<usb-storage@lists.one-eyed-alien.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've tried it again and only w is needed.  Previously I was not
resetting the MP3 player between tests ( as I did this time )

Russell

On Wed, Feb 1, 2012 at 4:22 AM, Matthew Dharm
<mdharm-usb@one-eyed-alien.net> wrote:
> The 'rw' sets the flags to "ignore residue" and "skip write-protect
> checking".  Are both flags really needed?
>
> Matt
>
> On Tue, Jan 31, 2012 at 2:44 AM, Russell Strong <russell@strong.id.au> wrote:
>> Hi Matthew,
>>
>> I pulled you name from the kernel maintainers file to let someone know
>> about a quirk that I discovered with an MP3 player that connects as
>> usb-storage.  Hope I've got this right.
>>
>> When I connected it to my fedora 8/14/16 machine ( sorry not the
>> latest kernel ) it didn't work.  The following is the dmesg output:
>>
>> [ 1703.287204] usb 2-1: new high speed USB device using ehci_hcd and address 4
>> [ 1703.402018] usb 2-1: New USB device found, idVendor=1e74, idProduct=4641
>> [ 1703.402025] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>> [ 1703.402030] usb 2-1: Product: USB
>> [ 1703.402034] usb 2-1: Manufacturer:
>> [ 1703.402037] usb 2-1: SerialNumber: USBV1.00
>> [ 1703.402840] scsi5 : usb-storage 2-1:1.0
>> [ 1704.403915] scsi 5:0:0:0: Direct-Access              USB DISK
>>   1.00 PQ: 0 ANSI: 0
>> [ 1704.409525] sd 5:0:0:0: Attached scsi generic sg3 type 0
>> [ 1704.411604] sd 5:0:0:0: [sdc] 15958016 512-byte logical blocks:
>> (8.17 GB/7.60 GiB)
>> [ 1704.514300] usb 2-1: reset high speed USB device using ehci_hcd and address 4
>> [ 1709.628307] usb 2-1: device descriptor read/all, error -110
>> [ 1709.730154] usb 2-1: reset high speed USB device using ehci_hcd and address 4
>> ....
>>
>> So I played around with the usb-storage parameter quirks, and found
>> that 1e74:4641:rw worked a treat.  Hope this is helpful.
>>
>> For all the others googling for this :
>> Dick Smith Electronics MP3 player 8GB
>> DSE
>> A8705
>> add kernel command line parameter usb-storage.quirks=1e74:4641:rw
>>
>> Regards,
>> Russell
>
>
>
> --
> Matthew Dharm
> Maintainer, USB Mass Storage driver for Linux
