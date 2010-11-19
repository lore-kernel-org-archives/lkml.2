Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750952Ab0KSF00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 00:26:26 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40505 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0KSF0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 00:26:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=x85mCdpl4zzkCuLMZ11DcYc5AI0dYJyyUhmE/aOm1kB/MQdSyYdsS8dotbLxL4G4d8
         froimJStixJIghz7+AqFpVhiwthBgbOsU4TrjsjEikumSTLy8eU2iQdZzNz2fqTgItID
         3xlqsHrpw3K6ahg2UMZj6f6VmGQyF9KeIu9/U=
MIME-Version: 1.0
In-Reply-To: <AANLkTikK9f0xzVUmO7g0ztq+wtEVX3y7ntq7zXgD5kqa@mail.gmail.com>
References: <AANLkTikK9f0xzVUmO7g0ztq+wtEVX3y7ntq7zXgD5kqa@mail.gmail.com>
Date: Fri, 19 Nov 2010 10:56:24 +0530
Message-ID: <AANLkTikU_HUXEoXuRAn0zoRmVke_32AWdqwC8fhkK0tZ@mail.gmail.com>
Subject: Fwd: Unknown error 513 in pthread_create after several hours of
 running a Gstreamer based application
From: parveen jain <parveenj16@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

  I am using Gstreamer for creating one of my video streaming
application. My application creates multimedia session and then stream
around 200 video sessions (a very processor intensive job).In doing
so, the no. of threads created is around 1500 and I have given around
1536 KB as my stack size for each of these threads. I have one
Quadcore(intel Xeon) system of around 8 GB of RAM(64 bit) with RHEL
5.5(kernel - 2.6.18-92.el5).

  After few hours of testing I see that my overall memory(RAM) is
eating up. I did checked the memory and I saw that my cache size is
growing. So far so good, as I can understand that system does cache
instead of leaving some RAM free.

   My problem comes, when I see that after almost 20-25 hours of
testing, RAM is continuously being eaten up and maximum part of that
is going into cache. If I leave the system for few more hours I see
whole of my memory is consumed up and now my swap started getting
used. If I check the cache now, I clearly see most of RAM is now in
form of cache. I still didn’t stop my application and allowed it run
for few more hours and after sometime I see that process give
segmentation fault while creating the pthread (create_pthread::unknown
error 513).I also tried to observe the “core” file of application
created in this way , but it doesn’t’ show anything.

  One thing I must mention that, in “top” I see almost constant values
of resident memory, virtual memory and shared memory. There is no
increase of memory usage here. So here I can assume that my
application is not leaking the memory. I also observed that if I kill
my application any time during this, the memory doesn’t go into free
pool.

   Anyone, here can give any pointer for this kind of behavior. Is it
can be because of some kernel BUG which is not freeing the memory to
application usage.

No need to mentioned that any help or clue will be highly appreciated
and regarded :)

Some other details:

Linux testing 2.6.18-92.el5 #1 SMP Tue Apr 29 13:16:15 EDT 2008 x86_64
x86_64 x86_64 GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17.50.0.6-6.el5
util-linux             2.13-pre7
mount                  2.13-pre7
module-init-tools      3.3-pre2
e2fsprogs              1.39
quota-tools            3.13.
PPP                    2.4.4
Linux C Library        > libc.2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.97
udev                   095
Modules Loaded         autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6
xfrm_nalgo crypto_api dm_mirror dm_multipath dm_mod video sbs
backlight i2c_ec button battery asus_acpi acpi_memhotplug ac lp
i2c_i801 ide_cd i2c_core shpchp e1000 tg3 cdrom parport_pc parport
i5000_edac serio_raw edac_mc sg pcspkr ata_piix libata aacraid sd_mod
scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd

Best Regards,
Parveen Jain
