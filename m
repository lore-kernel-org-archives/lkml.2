Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab1GYLKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 07:10:07 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:57191 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1GYLKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 07:10:03 -0400
Date: Mon, 25 Jul 2011 08:10:00 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Dave Airlie <airlied@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] [BISECTED] Unable to use 3D with Radeon 2100 and UI
 freezes with Firefox
Message-ID: <20110725111000.GA2275@ime.usp.br>
References: <20110724130336.GA2116@ime.usp.br>
 <CAPM=9txTVVxvv85kcZqBVjmpVK1zsAvVarLv1Sm7viwfF+ZYyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPM=9txTVVxvv85kcZqBVjmpVK1zsAvVarLv1Sm7viwfF+ZYyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Dear Dave, Thomas and other people,

On Jul 25 2011, Dave Airlie wrote:
> 2011/7/24 Rogério Brito <rbrito@ime.usp.br>:
> > Here I have the dmesg output slightly edited with the points that I
> > think that are the most relevant to the problem. Please note that my
> > understanding of devices/hardware is next to nothing and I may have cut
> > important parts.
> 
> Can you attach /proc/interrupts as well please.

Sure, I am attaching the contents of /proc/interrupts from both a kernel
that works and one that doesn't.

Please, advise if you want more information and how you would prefer me to
send them. I will do my best to get those to you.


Thanks,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="proc-interrupts-works.txt"

           CPU0       CPU1       CPU2       CPU3       
  0:         43          0          0          1   IO-APIC-edge      timer
  1:          0          0          0          2   IO-APIC-edge      i8042
  7:          1          0          0          0   IO-APIC-edge      parport0
  8:          0          0          0          1   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 10:          0          0          0          0   IO-APIC-fasteoi   radeon
 12:          0          0          0          4   IO-APIC-edge      i8042
 16:          0          0         25       5260   IO-APIC-fasteoi   ohci_hcd:usb3, ohci_hcd:usb4, hda_intel
 17:          0          0          0          2   IO-APIC-fasteoi   ehci_hcd:usb1
 18:          0          1         24       4448   IO-APIC-fasteoi   ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7
 19:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb2
 22:          0          2         51      13245   IO-APIC-fasteoi   ahci
 41:          0          1        154      10606   PCI-MSI-edge      eth0
NMI:          0          0          0          0   Non-maskable interrupts
LOC:      20027      15490       8861      18882   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RES:      22631      17487       7215       3252   Rescheduling interrupts
CAL:        652        869       1070        485   Function call interrupts
TLB:       2519       1944       1436       2708   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          1          1          1          1   Machine check polls
ERR:          1
MIS:          0

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="proc-interrupts-doesnt-work.txt"

           CPU0       CPU1       CPU2       CPU3       
  0:         41          0          0          1   IO-APIC-edge      timer
  1:          0          0          0          2   IO-APIC-edge      i8042
  7:          1          0          0          0   IO-APIC-edge      parport0
  8:          0          0          0          1   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 10:          0          0          0          0   IO-APIC-fasteoi   radeon
 12:          0          0          0          4   IO-APIC-edge      i8042
 16:          0          1        145       1080   IO-APIC-fasteoi   ohci_hcd:usb3, ohci_hcd:usb4, hda_intel
 17:          0          0          0          2   IO-APIC-fasteoi   ehci_hcd:usb1
 18:          3          1        109      99890   IO-APIC-fasteoi   ohci_hcd:usb5, ohci_hcd:usb6, ohci_hcd:usb7
 19:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb2
 22:          0          4        393      10750   IO-APIC-fasteoi   ahci
 41:          0          0          0         85   PCI-MSI-edge      eth0
NMI:          0          0          0          0   Non-maskable interrupts
LOC:      10001       7584       5251      10844   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RES:       9456       7990       4427       1996   Rescheduling interrupts
CAL:        699        786        924        292   Function call interrupts
TLB:        577       1124        748        447   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          1          1          1          1   Machine check polls
ERR:          1
MIS:          0

--qDbXVdCdHGoSgWSk--
