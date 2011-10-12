Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab1JLAZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 20:25:58 -0400
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:51435 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab1JLAZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 20:25:57 -0400
Date: Tue, 11 Oct 2011 20:25:56 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: Slow write performance with mpt2sas
Message-ID: <20111012002556.GA32495@animx.eu.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed that my SAS9212-4i4e is having write issues.  I have a raid5 of
4 2tb seagate green drives and a raid5 of 3 300gb seagate 15k sas drives. 
Write performance on the green drives is fairly poor.  The riad4 of 4 disks
has a write performance of about 6-10mb/sec.  My onboard sas controller
(1068e chip IT mode) does not have this issue (I'm using raid6 on 8 of the
same model green drives).

Write performance on the 15k drives in raid 5 was 140mb/sec (4gb volume).

Here's some information from lsi's sas2flash util:
        Controller                     : SAS2008(B1)   
        PCI Address                    : 00:03:00:00
        SAS Address                    : 500605b-0-01d0-ab00
        NVDATA Version (Default)       : 0a.03.00.02
        NVDATA Version (Persistent)    : 0a.03.00.02
        Firmware Product ID            : 0x2713 
        Firmware Version               : 11.00.00.00
        NVDATA Vendor                  : LSI
        NVDATA Product ID              : SAS9212-4i4e
        BIOS Version                   : 07.21.00.00
        UEFI BSD Version               : N/A
        FCODE Version                  : N/A
        Board Name                     : SAS9212-4i4e
        Board Assembly                 : H3-25134-00A
        Board Tracer Number            : P131430410

I'm using stock kernel 2.6.39 compiled for 64-bit.  This sas controller has
IR firmware.

Relevent information from dmesg:
[    1.585459] mpt2sas version 08.100.00.00 loaded
[    1.585564] scsi0 : Fusion MPT SAS Host
[    1.585772] mpt2sas 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.585846] mpt2sas 0000:03:00.0: setting latency timer to 64
[    1.585849] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (12301640 kB)
[    1.585966] mpt2sas0: IO-APIC enabled: IRQ 16
[    1.586027] mpt2sas0: iomem(0x00000000fac3c000), mapped(0xffffc90000020000), size(16384)
[    1.586110] mpt2sas0: ioport(0x000000000000a000), size(256)
[    1.872511] mpt2sas0: sending diag reset !!
[    2.355485] Refined TSC clocksource calibration: 2133.333 MHz.
[    2.355561] Switching to clocksource tsc
[    2.974166] mpt2sas0: diag reset: SUCCESS
[    3.121510] mpt2sas0: Allocated physical memory: size(3999 kB)
[    3.121574] mpt2sas0: Current Controller Queue Depth(1753), Max Controller Queue Depth(2000)
[    3.121659] mpt2sas0: Scatter Gather Elements per IO(128)
[    3.353750] mpt2sas0: LSISAS2008: FWVersion(11.00.00.00), ChipRevision(0x02), BiosVersion(07.21.00.00)
[    3.353848] mpt2sas0: Protocol=(Initiator), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
[    3.354367] mpt2sas0: sending port enable !!
[    4.888265] mpt2sas0: host_add: handle(0x0001), sas_addr(0x500605b001d0ab00), phys(8)
[   10.998203] mpt2sas0: port enable: SUCCESS

Any suggestions?

PS. I am on the list.  I do prefer courtesy CC.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
