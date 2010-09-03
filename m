Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab0ICQrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 12:47:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37792 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab0ICQra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 12:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=StkR0l9Y64uEffxM1RI37qMRFBAdYg6W7Gtt5pcvSjKKPxSU4lXF7Rr/VIFDfKXjPw
         QihHOB140znbVfBxvNwBe5WzQLPmLFyPHFfQ0Wke2CWZqdeee823a+X9hisLFj8P2tBE
         R5XDjQBJnFpJeKOwIhFZ6ryAAOhAWqYRbQc3M=
MIME-Version: 1.0
In-Reply-To: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC1282645A@Mercury.usurf.usu.edu>
References: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC12824E74@Mercury.usurf.usu.edu>
	<4C803FE0.10001@gmail.com>
	<5ABE8A5E96C0364CAF2B4DC1DEB7CEAC1282645A@Mercury.usurf.usu.edu>
Date: Fri, 3 Sep 2010 10:47:29 -0600
Message-ID: <AANLkTin3rW7LZe4=YSNsMAhKdbrxBGtLyE0qKi=bc4td@mail.gmail.com>
Subject: Re: sata_sil24 memory fragmentation issues
From: Robert Hancock <hancockrwd@gmail.com>
To: Jonathan Haws <Jonathan.Haws@sdl.usu.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 3, 2010 at 8:46 AM, Jonathan Haws <Jonathan.Haws@sdl.usu.edu> wrote:
>> I am having some issues with the sata_sil24 driver.  It appears that when memory gets fragmented enough, bad things start to happen.  However, this only occurs when I am receiving large amounts of data over the network as well.
>>
>> Here is my test setup:  I am running an AMCC 405EX processor on their Kilauea development board.  I have a PCIe SATA controller based on the 3531 single port chip (which uses the sata_sil24 driver).  I have a program that simply dumps data out to disk.  When I am running that program, I am also running ping -s 8500<some-ip>.
>>
>> Here is the output:
>>
>> 8508 bytes from 172.31.22.21: seq=137 ttl=128 time=1.306 ms
>>    CNT:        129 WRIT:   35651584 RATE: 34.00000 MB/s READ:          0 RATE: 0.00000 MB/s AVG WR: 34.17188 MB/s AVG RD: 0.00000 MB/s
>> 8508 bytes from 172.31.22.21: seq=138 ttl=128 time=1.254 ms
>>    CNT:        130 WRIT:   34603008 RATE: 33.00000 MB/s READ:          0 RATE: 0.00000 MB/s AVG WR: 34.16279 MB/s AVG RD: 0.00000 MB/s
>> 8508 bytes from 172.31.22.21: seq=139 ttl=128 time=1.291 ms
>>    CNT:        131 WRIT:   34603008 RATE: 33.00000 MB/s READ:          0 RATE: 0.00000 MB/s AVG WR: 34.15385 MB/s AVG RD: 0.00000 MB/s
>> 8508 bytes from 172.31.22.21: seq=140 ttl=128 time=1.254 ms
>>    CNT:        132 WRIT:   35651584 RATE: 34.00000 MB/s READ:          0 RATE: 0.00000 MB/s AVG WR: 34.15267 MB/s AVG RD: 0.00000 MB/s
>> sata: page allocation failure. order:0, mode:0x22
>
>>sata is the process name, I believe? Not sure the SATA driver is
>>involved here at all.
>
> I think it is because if you look at the call trace, the exception occurs down in the kernel.  The driver I am using is the sata_sil24 driver and doing some searches online, others have experienced similar problems when the system is under heavy load (such as a high level of network interrupts).  Unfortunately the solutions to those problems is to go with different SATA controllers, which is not an option for me.
>
> However, when you mention that the driver is not involved, are you implying that there may be a bug in my program?  I will go back and look through my code, but it is a really dumb program - I have a large statically allocated buffer that I write to disk over and over again.  I will go back and check to make sure I am not doing anything stupid, but I don't think I am.

I meant that "sata" is just the process name (I assume), it's not
really anything to do with the SATA driver. Normally SATA host
controller drivers don't really allocate memory at runtime so this
wouldn't really be an issue with them. Network controllers do in order
to handle received packets, though - it appears that for some reason
the memory allocation by the network driver is failing.

I'm not really sure why that is - it seems like you do have memory
available. Hopefully some VM guru can pipe up with a suggestion.
