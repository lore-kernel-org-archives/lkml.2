Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab1DQRM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 13:12:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46587 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab1DQRMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 13:12:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=X0NWPr6AK9dOega4ikDZzsQcjfrHb1PXWUj9LBYeb+Tv0cwr/x/3g76Ed5zg1nBMZ8
         LUp+SuzNGWR+38DPcMchRlrLSQ1SETqCrCsriBK590Jggj4cR2e0vFboWKSkAZzObYQW
         WxCju+BWwLdKNpIPA3FpFcRP5qqIxx7K1FByw=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Tim Shepard <shep@alum.mit.edu>
Subject: Re: 2.6.39-rc3 udevadm settle timeout, many hdb events, interrupt storm
Date: Sun, 17 Apr 2011 19:12:45 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc3; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <E1Q9j2p-0008Rr-00@www.xplot.org>
In-Reply-To: <E1Q9j2p-0008Rr-00@www.xplot.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104171912.45583.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=33412
for your bug report, please add your address to the CC list in there, thanks!

On wtorek, 12 kwietnia 2011 o 21:14:35 Tim Shepard wrote:
> 2.6.38 is working fine on my PowerBook G4 (powerpc) and has none of
> the issues described below.
> 
> Last week I tried 2.6.39-rc2 and it hung on reboot.
> Same thing with 2.6.39-rc3 this week.
> 
> I've tracked this down to the "udevadm settle" in /etc/init.d/udev
> (from Debian squeeze).
> 
> If I am patient it does timeout after 180 seconds and continues
> booting.  But after booting finishes udev is still chewing CPU cycles
> and load average is stuck at 1.
> 
> After the system is up:
> 
> # udevadm monitor
> monitor will print the received events for:
> UDEV - the event which udev sends out after rule processing
> KERNEL - the kernel uevent
> 
> KERNEL[1302632376.412055] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632376.460742] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block) UDEV 
> [1302632376.501101] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632376.510745] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632376.560742] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block) UDEV 
> [1302632376.601155] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632376.610755] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632376.660744] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block) UDEV 
> [1302632376.701186] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632376.710751] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632376.760727] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block) UDEV 
> [1302632376.801135] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632376.810753] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632376.860748] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block) UDEV 
> [1302632376.901068] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632376.910748] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632376.960746] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block) UDEV 
> [1302632377.004023] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632377.010786] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632377.210681] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632377.260749] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block) UDEV 
> [1302632377.301096] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632377.310749] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632377.360749] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block) UDEV 
> [1302632377.401136] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632377.410753] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632377.460748] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block) UDEV 
> [1302632377.501264] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632377.510749] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632377.560730] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block) UDEV 
> [1302632377.601147] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block)
> KERNEL[1302632377.610793] change  
> /devices/pci0002:24/0002:24:0d.0/ide0/0.1/block/hdb (block) ^C#
> #
> #
> # dmesg | grep hdb
> hdb: MATSHITADVD-R UJ-846, ATAPI CD/DVD-ROM drive
> hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> hdb: UDMA/66 mode selected
> ide-cd: hdb: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
> #
> # dmesg | grep ide
> radeonfb: Using Firmware dividers 0x00040089 from PPLL 0
> ide-pmac 0002:24:0d.0: enabling device (0000 -> 0002)
> ide-pmac: Found Apple UniNorth ATA-6 controller (PCI), bus ID 3, irq 39
> Probing IDE interface ide0...
> ide0 at 0xf106a000-0xf106a070,0xf106a160 on irq 39
> ide-gd driver 1.18
> ide-cd driver 5.00
> ide-cd: hdb: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
> #
> 
> 
> I am getting over 1300 interrupts per second for ide0:
> 
> # while grep ide /proc/interrupts && sleep 1 ; do : ; done
>  39:     722724   MPIC 1     ide0
>  39:     723042   MPIC 1     ide0
>  39:     723364   MPIC 1     ide0
>  39:     723685   MPIC 1     ide0
>  39:     724012   MPIC 1     ide0
>  39:     724334   MPIC 1     ide0
>  39:     724656   MPIC 1     ide0
>  39:     724978   MPIC 1     ide0
>  39:     725296   MPIC 1     ide0
>  39:     725615   MPIC 1     ide0
>  39:     725936   MPIC 1     ide0
>  39:     726257   MPIC 1     ide0
>  39:     726577   MPIC 1     ide0
>  39:     726901   MPIC 1     ide0
>  39:     727226   MPIC 1     ide0
>  39:     727549   MPIC 1     ide0
>  39:     727868   MPIC 1     ide0
>  39:     728190   MPIC 1     ide0
>  39:     728512   MPIC 1     ide0
>  39:     728833   MPIC 1     ide0
>  39:     729152   MPIC 1     ide0
>  39:     729473   MPIC 1     ide0
>  39:     729800   MPIC 1     ide0
>  39:     730111   MPIC 1     ide0
>  39:     730435   MPIC 1     ide0
>  39:     730755   MPIC 1     ide0
>  39:     731083   MPIC 1     ide0
>  39:     731402   MPIC 1     ide0
>  39:     731720   MPIC 1     ide0
>  39:     732052   MPIC 1     ide0
>  39:     732368   MPIC 1     ide0
>  39:     732689   MPIC 1     ide0
>  39:     733010   MPIC 1     ide0
> ^C
> 
> 
> 
> I tried using the CDROM drive and it actually does work (as /dev/hdb).
> So the only real problems are the 180 second hang while booting and
> the interrupt storm and udev event storm that continues.
> 
> Any hints?
> 
> 
> 			-Tim Shepard
> 			 shep@alum.mit.edu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
