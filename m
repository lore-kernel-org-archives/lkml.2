Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab1ANScv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:32:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab1ANSct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:32:49 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Alberto Mattea <alberto@mattea.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sata_nv silently ignores discard (TRIM) command?
References: <201101141850.25252@alby>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 14 Jan 2011 13:32:45 -0500
In-Reply-To: <201101141850.25252@alby> (Alberto Mattea's message of "Fri, 14
	Jan 2011 18:50:24 +0100")
Message-ID: <x49mxn39vzm.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alberto Mattea <alberto@mattea.info> writes:

> Hello all.
> I'm testing linux 2.6.37 final with a Crucial RealSSD C300 (256GB).
> The chipset is a nforce 570 (M2N32-SLI Deluxe); lspci:
> IDE interface [0101]: nVidia Corporation MCP55 SATA Controller [10de:037f] 
> (rev a2) (prog-if 85 [Master SecO PriO])
>         Subsystem: ASUSTeK Computer Inc. Device [1043:cb84]
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0 (750ns min, 250ns max)
>         Interrupt: pin C routed to IRQ 21
>         Region 0: I/O ports at f200 [size=8]
>         Region 1: I/O ports at f100 [size=4]
>         Region 2: I/O ports at f000 [size=8]
>         Region 3: I/O ports at ef00 [size=4]
>         Region 4: I/O ports at ee00 [size=16]
>         Region 5: Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: [44] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [b0] MSI: Enable- Count=1/4 Maskable- 64bit+
>                 Address: 0000000000000000  Data: 0000
>         Capabilities: [cc] HyperTransport: MSI Mapping Enable+ Fixed+
>         Kernel driver in use: sata_nv
>         Kernel modules: sata_nv
>
> On the device there is a single ext4 partition, mounted with -o discard. 
> Dmesg:
> EXT4-fs (sda1): re-mounted. Opts: errors=remount-
> ro,discard,data=writeback,commit=0
>
> To test whether TRIM is working, I did the following:
> # dd if=/dev/urandom of=tempfile count=100 bs=512k oflag=direct
> # hdparm --fibmap tempfile
> (File begins at 66090496)
> # hdparm --read-sector 66090496 /dev/sda
> (Random data)
> # rm tempfile
> # sync
> # hdparm --read-sector 66090496 /dev/sda
> Now, if I'm correct after a successful TRIM the last command should output all 
> zeroes, but exactly the same random data is reported instead. However, there 
> is nothing in dmesg about TRIM failing. Does sata_nv support TRIM on the 570?

What does 'cat /sys/block/sda/queue/discard_zeroes_data' say?

Cheers,
Jeff
