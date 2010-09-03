Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab0ICOqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:46:36 -0400
Received: from sati.usurf.usu.edu ([129.123.194.129]:17236 "EHLO
	echo.usurf.usu.edu" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab0ICOqc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:46:32 -0400
From: Jonathan Haws <Jonathan.Haws@sdl.usu.edu>
To: Robert Hancock <hancockrwd@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: sata_sil24 memory fragmentation issues
Thread-Topic: sata_sil24 memory fragmentation issues
Thread-Index: ActKwLAZ2DuCZ89NRQO65hb+Lsx0hAAb8JMAABEaJpk=
Date: Fri, 3 Sep 2010 14:46:31 +0000
Message-ID: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC1282645A@Mercury.usurf.usu.edu>
References: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC12824E74@Mercury.usurf.usu.edu>,<4C803FE0.10001@gmail.com>
In-Reply-To: <4C803FE0.10001@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.31.22.105]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am having some issues with the sata_sil24 driver.  It appears that when memory gets fragmented enough, bad things start to happen.  However, this only occurs when I am receiving large amounts of data over the network as well.
>
> Here is my test setup:  I am running an AMCC 405EX processor on their Kilauea development board.  I have a PCIe SATA controller based on the 3531 single port chip (which uses the sata_sil24 driver).  I have a program that simply dumps data out to disk.  When I am running that program, I am also running ping -s 8500<some-ip>.
>
> Here is the output:
>
> 8508 bytes from 172.31.22.21: seq=137 ttl=128 time=1.306 ms
>    CNT:        129 WRIT:   35651584 RATE: 34.00000 MB/s READ:          0 RATE: 0.00000 MB/s AVG WR: 34.17188 MB/s AVG RD: 0.00000 MB/s
> 8508 bytes from 172.31.22.21: seq=138 ttl=128 time=1.254 ms
>    CNT:        130 WRIT:   34603008 RATE: 33.00000 MB/s READ:          0 RATE: 0.00000 MB/s AVG WR: 34.16279 MB/s AVG RD: 0.00000 MB/s
> 8508 bytes from 172.31.22.21: seq=139 ttl=128 time=1.291 ms
>    CNT:        131 WRIT:   34603008 RATE: 33.00000 MB/s READ:          0 RATE: 0.00000 MB/s AVG WR: 34.15385 MB/s AVG RD: 0.00000 MB/s
> 8508 bytes from 172.31.22.21: seq=140 ttl=128 time=1.254 ms
>    CNT:        132 WRIT:   35651584 RATE: 34.00000 MB/s READ:          0 RATE: 0.00000 MB/s AVG WR: 34.15267 MB/s AVG RD: 0.00000 MB/s
> sata: page allocation failure. order:0, mode:0x22

>sata is the process name, I believe? Not sure the SATA driver is
>involved here at all.

I think it is because if you look at the call trace, the exception occurs down in the kernel.  The driver I am using is the sata_sil24 driver and doing some searches online, others have experienced similar problems when the system is under heavy load (such as a high level of network interrupts).  Unfortunately the solutions to those problems is to go with different SATA controllers, which is not an option for me.

However, when you mention that the driver is not involved, are you implying that there may be a bug in my program?  I will go back and look through my code, but it is a really dumb program - I have a large statically allocated buffer that I write to disk over and over again.  I will go back and check to make sure I am not doing anything stupid, but I don't think I am.

Thanks,

Jonathan