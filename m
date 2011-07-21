Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1GUSNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:13:18 -0400
Received: from acheron.ifi.lmu.de ([129.187.214.135]:52953 "EHLO
	acheron.ifi.lmu.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1GUSNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:13:17 -0400
From: Michael Brade <brade@informatik.uni-muenchen.de>
Organization: =?iso-8859-1?q?Ludwig-Maximilians-Universit=E4t?= 
 =?iso-8859-1?q?_M=FCnchen?=
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.39, 3.0.0-rc7+: complete system freeze with rsync on big directory
Date: Thu, 21 Jul 2011 20:13:14 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6; KDE/4.6.5; x86_64; ; )
Cc: Lars =?iso-8859-1?q?T=E4uber?= <taeuber@bbaw.de>
References: <201107211119.15496.brade@informatik.uni-muenchen.de> <20110721112804.7aa0043d.taeuber@bbaw.de>
In-Reply-To: <20110721112804.7aa0043d.taeuber@bbaw.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107212013.14561.brade@informatik.uni-muenchen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

> > Any ideas how to debug this despite the freeze? Do you need my kernel
> > config? Do you need any other info? Please CC me.
> 
> Could you try to capture the log via serial console?
> (linux/Documentation/serial-console.txt)

Hm. I don't have a serial port on my laptop and I don't have a USB dongle, so 
I don't know how to do this. And really, when it freezes, everything freezes. 
Even the HDD light just stops right where it is - either on of off all the 
time. None of the buttons work anymore, the CPU fan keeps going the speed it 
had before, no network responses anymore. Only holding the power button for 4 
seconds switches it off.

But watching the normal console I get loads of

r8169 0000:13:00.0: eth0: link up
r8169 0000:13:00.0: eth0: link up
[...]

one message about every 1-2 seconds while rsync is running on 2.6.37.6. 

On 2.6.39 and 3.0.0-rc7 I get about 2-3 of those per second - until it 
freezes. The source partition is iSCSI so it does use the net.
 
> What kind of disks/controller/driver do you use?

Source HD is iSCSI over ethernet. I am using open-iscsi on the client.

Dest HD is on the laptop:
  block device: bus = scsi, bus_id = 0:0:0:0 driver = sd
  model = WDC WD5000BEKT-7
  Driver: "ahci", "sd"
  SATA controller

lspci:

00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 port 
SATA AHCI Controller (rev 06)
13:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI 
Express Gigabit Ethernet controller (rev 03)

I guess my .config could also be helpful - if so, do you need all of it, part 
of it, and how should I post this? Attach it packed with 7z?

cheers,
  Michael
