Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab1EDJs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:48:28 -0400
Received: from filoni2.nine.ch ([94.230.212.32]:54062 "EHLO mail.lenux.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab1EDJs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:48:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 04 May 2011 11:48:25 +0200
From: jdossantos@docs.homelinux.org
To: Hank Janssen <hjanssen@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>, <linux-kernel@vger.kernel.org>
Subject: Re: Error in Hyper-V modules =?UTF-8?Q?hv=5Fvmbus?=
Message-ID: <0e67fbb5ce27bd8d1210f0b7b8d5069c@docs.homelinux.org>
User-Agent: Roundcube Webmail/0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> > > -----Original Message-----
>> > > From: root@docs.homelinux.org [mailto:root@docs.homelinux.org]
>> > > Sent: Tuesday, May 03, 2011 10:52 AM
>> > > To: KY Srinivasan
>> > > Cc: linux-kernel@vger.kernel.org
>> > > Subject: RE: Error in Hyper-V modules hv_vmbus
>> > >
>> > >  On Tue, 3 May 2011 13:42:43 +0000, KY Srinivasan wrote:
>> > > >> -----Original Message-----
>> > > >> From: root [mailto:root@docs.homelinux.org]
>> > > >> Sent: Sunday, May 01, 2011 8:37 AM
>> > > >> To: KY Srinivasan
>> > > >> Cc: linux-kernel@vger.kernel.org
>> > > >> Subject: Re: Error in Hyper-V modules hv_vmbus
>> > > >>
>> > > >> Windows Server Core 2008 R2 with SP2
>> > > >
>> > > > This is a known problem and a fix has been submitted - the 
>> patch
>> > > > is yet to be applied though. Once the hv patches that are in 
>> the
>> > > > queue are applied, this problem will be fixed. In the interim, 
>> if
>> > > > you want an immediate fix, I could send you the patch that 
>> will
>> > > > apply against the tree you have.
>> > > >
>> > > > Regards,
>> > > >
>> > > > K. Y
>> > > >>
>> > > >> Regards
>> > > >> Juan Dos Santos
>> > >
>> > >  Could You send me the patch? So I can test it, I am using the
>> > > kernel source from
>> > > 
>> http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.39-rc5
>> > > .t ar.bz2,  is the patch compatible with this kernel source?
>> >
>> > This is a very old version of the hyper-V driver code compared to 
>> what
>> > is in Greg's tree and looking at the code It does not look like 
>> the
>> > problem you are seeing is the problem my patch fixes. We will do 
>> some
>> > additional testing and get back to you. It would be very useful if 
>> you
>> > can post the dmesg or stack trace that can shed additional light 
>> on the
>> problem.
>
> Juan,
>
> I just fixed a few issues in Ubuntu 10.10 that might be similar.
>
> I will spin up a debian system and see if I can reproduce the problem 
> and
> submit a patch To fix it.
>
> Hank.

 Here is my step by step protocol:

 VM configuration:
 Host: Windows Server 2008 Core R2 with SP1
 Networkcard: Old emulated card
 Integratedservices: Shutdown, Timesync, Heartbeat
 CPU: 4
 Memory: 512 MB
 Harddisk: IDE 10 GB

 OS Installation:
 Debian Squeeze 6.0.1a (2.6.32-5-amd64)
 Standard installation without any installation packages

 Kernel installation:
 aptitude install kernel-package libncurses-dev
 cd /usr/src
 wget 
 http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.39-rc6.tar.bz2
 tar xfvj linux-2.6.39-rc6.tar.bz2
 cd linux-2.6.39-rc6/
 make clean
 make mrproper
 cp /boot/config-2.6.32-5-amd64 .config
 make menuconfig

 {Divice Drivers -> Stagin Drivers -> <M> Microsoft Hyper-V client 
 drivers}
 Here You can find the .config file http://docs.homelinux.org/hv/.config


 export CUNCURRENCY_LEVEL=4
 make-kpkg --append-to-version "-hyperv" --revision "1" --us --uc 
 --initrd kernel_image kernel_headers
 cd ..
 dpkg -i linux-image-2.6.39-rc6-hyperv_1_amd64.deb 
 linux-headers-2.6.39-rc6-hyperv_1_amd64.deb
 ls -l /boot/
 total 27640
 -rw-r--r-- 1 root root   106088 Mar  8 01:18 config-2.6.32-5-amd64
 -rw-r--r-- 1 root root   125214 May  4 11:31 config-2.6.39-rc6-hyperv
 drwxr-xr-x 3 root root     4096 May  4 12:56 grub
 -rw-r--r-- 1 root root  9095609 May  4 09:10 initrd.img-2.6.32-5-amd64
 -rw-r--r-- 1 root root 10388314 May  4 12:56 
 initrd.img-2.6.39-rc6-hyperv
 -rw-r--r-- 1 root root  1662514 Mar  8 01:18 System.map-2.6.32-5-amd64
 -rw-r--r-- 1 root root  1839410 May  4 12:52 
 System.map-2.6.39-rc6-hyperv
 -rw-r--r-- 1 root root  2418720 Mar  8 01:12 vmlinuz-2.6.32-5-amd64
 -rw-r--r-- 1 root root  2590800 May  4 12:52 vmlinuz-2.6.39-rc6-hyperv
 reboot

 After the reboot I get the "INFO: task modprobe:307 blocked for more 
 than 120 seconds." message
 and boot is haning for 170 seconds, here are the logs:
 http://docs.homelinux.org/hv/syslog
 http://docs.homelinux.org/hv/messages
 http://docs.homelinux.org/hv/dmesg

 lsmod | grep hv_
 hv_timesource           1055  0 [permanent]
 hv_vmbus               48554  1

 In the logs and with lsmod i see the timesource module running, but the 
 time is not in sync with the windows host.
 Shutdown function also dosn't work, seems that nothing of the 
 integrated components are working..hv_netvsc,hv_blkvsc,hv_storvsc are 
 not
 loaded?! But modinfo provides information:

 modinfo hv_vmbus
 filename:       
 /lib/modules/2.6.39-rc6-hyperv/kernel/drivers/staging/hv/hv_vmbus.ko
 version:        3.1
 license:        GPL
 srcversion:     334F59AED9605F8C3B7696F
 alias:          pci:v00001414d00005353sv*sd*bc*sc*i*
 alias:          
 dmi*:svn*MicrosoftCorporation*:pn*VirtualMachine*:rn*VirtualMachine*:
 depends:
 staging:        Y
 vermagic:       2.6.39-rc6-hyperv SMP mod_unload modversions
 parm:           vmbus_irq:int
 parm:           vmbus_loglevel:int

 modinfo hv_timesource
 filename:       
 /lib/modules/2.6.39-rc6-hyperv/kernel/drivers/staging/hv/hv_timesource.ko
 license:        GPL
 author:         K. Y. Srinivasan <ksrinivasan@novell.com>
 description:    HyperV based clocksource
 alias:          pci:v00001414d00005353sv*sd*bc*sc*i*
 alias:          
 dmi*:svn*MicrosoftCorporation*:pn*VirtualMachine*:rn*VirtualMachine*:
 depends:
 staging:        Y
 vermagic:       2.6.39-rc6-hyperv SMP mod_unload modversions

 modinfo hv_netvsc
 filename:       
 /lib/modules/2.6.39-rc6-hyperv/kernel/drivers/staging/hv/hv_netvsc.ko
 description:    Microsoft Hyper-V network driver
 version:        3.1
 license:        GPL
 srcversion:     EA7C82EAB799B90B4F6BFA6
 alias:          pci:v00001414d00005353sv*sd*bc*sc*i*
 alias:          
 dmi*:svn*MicrosoftCorporation*:pn*VirtualMachine*:rn*VirtualMachine*:
 depends:        hv_vmbus
 staging:        Y
 vermagic:       2.6.39-rc6-hyperv SMP mod_unload modversions
 parm:           ring_size:Ring buffer size (# of pages) (int)

 modinfo hv_storvsc
 filename:       
 /lib/modules/2.6.39-rc6-hyperv/kernel/drivers/staging/hv/hv_storvsc.ko
 description:    Microsoft Hyper-V virtual storage driver
 version:        3.1
 license:        GPL
 srcversion:     23688D30D5A66982D2BB67F
 depends:        scsi_mod,hv_vmbus
 staging:        Y
 vermagic:       2.6.39-rc6-hyperv SMP mod_unload modversions
 parm:           storvsc_ringbuffer_size:Ring buffer size (bytes) (int)

 modinfo hv_blkvsc
 filename:       
 /lib/modules/2.6.39-rc6-hyperv/kernel/drivers/staging/hv/hv_blkvsc.ko
 description:    Microsoft Hyper-V virtual block driver
 version:        3.1
 license:        GPL
 srcversion:     5B375CF1D6F5581A05B1026
 depends:        scsi_mod,hv_vmbus
 staging:        Y
 vermagic:       2.6.39-rc6-hyperv SMP mod_unload modversions
 parm:           blkvsc_ringbuffer_size:int
 parm:           ring_size:Ring buffer size (in bytes)


 After that I enabled the synthetic network card, but also here..it 
 doesn't work and I don't see any hv_netvsc
 module loaded, so I tried to load it "by hand" with modprobe 
 hv_netvsc..but I get a modprobe timeout and nothing happens..

 Can someone repruduce it? Is there a patch for kernel linux-2.6.39-rc6?

 Regards
 Juan Dos Santos


