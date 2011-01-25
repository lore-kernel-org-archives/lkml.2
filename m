Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab1AYTML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 14:12:11 -0500
Received: from nm25.bullet.mail.ac4.yahoo.com ([98.139.52.222]:48663 "HELO
	nm25.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751598Ab1AYTMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:12:10 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 833822.13398.bm@omp1050.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=LGzMST4T9u0kOIDzreTytTLWO7y8OcOLinrgp4PwL9/HBWBLHhkvKg4XR2Javoh8cWegjhGHaLEV7udmm07R/m79jQMXfsu5/p2YzkNQXYKoW0lxL/p1Q1MZg8V3k4hXn5kTp3p0X3XP+T1UZnsnR+76JJKIC+NFW8vwXi2ZeF0=;
Message-ID: <583930.75035.qm@web161804.mail.bf1.yahoo.com>
X-YMail-OSG: wbUvzQ8VM1ne12Pbh.DnrGN0MvFVrvvszrWDvs2YvaTwGoj
 eNe6tBehTtTEFrWkOiHea5FVRBd_y7mCFbmrBgU051ZjA7zlKWwAYRV8iPTJ
 3OdiqXEWErXNlf7re84B.J_AC9mBlaTqZursVlCw.ZrXf4hizDwtEEe8UB5n
 a09.XobLcp6._3BxszWIacrTiU01kCQLScmWrKLqYN9V6kMrKrmYn683DuXH
 GtxVpTBep33rF7Zxi.NkjK6iXA.ZJQ.ini_XPrYGoPyGuwdB1dozshVKtbBm
 JQ1UtALzt
X-Mailer: YahooMailRC/555 YahooMailWebService/0.8.107.285259
Date: Tue, 25 Jan 2011 11:12:08 -0800 (PST)
From: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: SD card reads corrupted (JMicron card reader)
To: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Follow up to the original message: I have been trying to bisect the problem,
but haven't determined a definitely "good" kernel yet. The problem certainly
manifests itself on 2.6.36.3 when the config is straight from Arch Linux's
kernel26-headers 2.6.36.3-1 package. If I disable staging drivers (via
CONFIG_STAGING_EXCLUDE_BUILD=y), the problem goes away. Very
annoying to notice that after half a dozen kernel compiles.

Anyway, I have two versions of the 2.6.36.3 kernel+modules, one with
staging drivers (bad) and one without (good). If I take the vmlinuz and
System.map files from the good version and put them together with
the bad modules, it works. So, something in the main kernel instead of
the modules, I assume, but what could be changing there with the staging
switch to cause such a specific problem? In the config all the staging
drivers are set to be modules.

Mikko



----- Original Message ----
> From: Mikko Vinni
> To: linux-mmc; Chris Ball
> Sent: Thu, January 20, 2011 11:04:23 PM
> Subject: SD card reads corrupted (JMicron card reader)
> 
> Hi,
> 
> I have an HP Pavilion dv5 laptop, which has an integrated memory card  reader
> (labeled with "SD*MS/Pro*MMC*XD) and appearing with lspci  as:
> 
> 0a:00.1 System peripheral: JMicron Technology Corp. SD/MMC Host  Controller
> 0a:00.2 SD Host controller: JMicron Technology Corp. Standard SD  Host 
>Controller
> 0a:00.3 System peripheral: JMicron Technology Corp. MS Host  Controller
> 0a:00.4 System peripheral: JMicron Technology Corp. xD Host  Controller
> 
> I have mainly used a 1 GB SD card from puremedia, but I have  seen the problem
> with another card as well. Basically, if I try to read image  files from the 
>card 
>
> using the
> card reader, the images come out corrupted  (having the card inside a Canon 
>Ixus 
>
> camera and reading the images via a USB  cable works).
> 
> The logs don't seem to contain anything  suspicious:
> 
> [ 1262.957504] sdhci: Secure Digital Host Controller  Interface driver
> [ 1262.957511] sdhci: Copyright(c) Pierre Ossman
> [  1262.962070] sdhci-pci 0000:0a:00.1: SDHCI controller found [197b:2382] (rev 
>
> 0)
> [ 1262.962105] sdhci-pci 0000:0a:00.1: PCI INT A -> GSI 18 (level,  low) -> IRQ 
>
> 18
> [ 1262.962275] sdhci-pci 0000:0a:00.1: setting latency  timer to 64
> [ 1262.963721] Registered led device: mmc0::
> [ 1262.964075]  mmc0: SDHCI controller on PCI [0000:0a:00.1] using DMA
> [ 1262.964110]  sdhci-pci 0000:0a:00.2: SDHCI controller found [197b:2381] (rev 
>
> 0)
> [  1262.964137] sdhci-pci 0000:0a:00.2: PCI INT A -> GSI 18 (level, low) ->  
>IRQ 
>
> 18
> [ 1262.964158] sdhci-pci 0000:0a:00.2: Refusing to bind to  secondary 
>interface.
> [ 1262.964170] sdhci-pci 0000:0a:00.2: PCI INT A  disabled
> [ 1266.834763] mmc0: new SD card at address 1234
> [ 1266.924222]  mmcblk0: mmc0:1234 SD01G 972 MiB 
> [ 1266.925586]  mmcblk0: p1
> [  2575.746579] mmc0: card 1234 removed
> [ 3544.629621] loop: module loaded
> [  4747.394461] mmc0: new SD card at address 1234
> [ 4747.394793] mmcblk0:  mmc0:1234 SD01G 972 MiB 
> [ 4747.396090]  mmcblk0: p1
> [ 5075.523021]  mmc0: card 1234 removed
> 
> I transferred some text files to the card and  back to see if there's some 
> regularity
> in the corruption, but it varies.  For example, of 100 files of varying sizes 
> (largest 98KB),
> at one point  11 files might be corrupted, and after umount/mount maybe 6.
> 
> I copied the  memory card file system to a file; loop mounting that file 
system
> gives one  stable (but corrupted) view of the files, so I suppose it's not a 
>file
> system  (vfat) issue, but something with the hardware.
> 
> Currently I am using a  custom 2.6.37 kernel (on 64 bit Arch Linux up to date), 
>
> but
> I have seen  corrupted images coming from the card reader on several previous
> kernels as  well.
> 
> Is there something I could test or some specific information I  should 
provide?
> 
> Here is one example of the corruption I am talking  about:
> - the source file 49.txt consists of  lines
> 0049-0001
> 0049-0002
> 0049-0003
> ...
> 0049-2399
> 0049-2400
> 0049-2401
> 
> The  file is exactly 24010 bytes long.
> 
> After transferring that file to the SD  card and back (via the card reader) and 
>
> taking a diff, the differences  are:
> 
> @@ -407,1995 +407,1992 @@
>  0049-0407
>  0049-0408
>   0049-0409
> -0049-0410
> -0049-0411
> -0049-0412
> ... (all lines in between  removed; each line is 10  bytes)
> -0049-2399
> -0049-2400
> -0049-2401
> +0049-00049-0001
> +0049-0002
> +0049-0003
> ...  (all lines in between  added)
> +0049-0408
> +0049-0409
> +0049-00049-0001
> +0049-0002
> +0049-0003
> ...
> +0049-0408
> +0049-0409
> +0049-00049-0001
> +0049-0002
> +0049-0003
> ...
> +0049-0407
> +0049-0408
> +0049-0409
> +0049-00049-0001
> +0049-0002
> +0049-0003
> ...
> +0049-0407
> +0049-0408
> +0049-0409
> +0049-00049-0001
> +0049-0002
> +0049-0003
> ...
> +0049-0351
> +0049-0352
> +0049-0353
> 
> Also  the corrupted file is exactly 24010 bytes long. In this case there seems
> to  be a chunk of 4096 bytes repeating. I'm in no way expert, but if  somebody
> thinks it's good to see if the other test files also contain similar  chunks of 
>
> 4096
> bytes, I can go through them or post them  here.
> 
> 
> Any help would be  appreciated.
> 
> Mikko


      
