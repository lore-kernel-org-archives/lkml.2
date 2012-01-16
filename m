Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2APT3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:29:34 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45983 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab2APT3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:29:32 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzqECJjbtgyOXy_H1smh09SsfgrAuVY7hK2sC-xj1GZHg@mail.gmail.com>
References: <20120109003255.GA6598@havoc.gtf.org> <CA+55aFwcBQSoWfqdT9CxV=GAr5ex0=RnqtBDFty+=_Lua2VXGw@mail.gmail.com>
 <4F12E57E.3090805@garzik.org> <1326676534.13517.3.camel@minggr>
 <1326691403.13517.21.camel@minggr> <CA+55aFzqECJjbtgyOXy_H1smh09SsfgrAuVY7hK2sC-xj1GZHg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jan 2012 11:29:10 -0800
X-Google-Sender-Auth: meIWXatJD34q-qalZRYLsJE3ODo
Message-ID: <CA+55aFy+1DWUaOMormPHy7hCJxNfdxmiAnj8W0gqNTbeogNN4w@mail.gmail.com>
Subject: Re: [git patches] libata updates for 3.3
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 11:25 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But why don't we fix the silly legacy mode thing? Yeah, Apple's
> firmware is crap and doesn't tend to initialize things, but still - we
> should have at least an option to not use the legacy PIIX mode just
> because the chipset wasn't programmed for AHCI by the bootup.

Here's the lspci output for that device, in case anybody cares:


  00:1f.2 IDE interface [0101]: Intel Corporation 6 Series/C200 Series
Chipset Family 4 port SATA IDE Controller [8086:1c01] (rev 05)
(prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: Intel Corporation Device [8086:7270]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 0: I/O ports at 2168 [size=8]
        Region 1: I/O ports at 217c [size=4]
        Region 2: I/O ports at 2160 [size=8]
        Region 3: I/O ports at 2178 [size=4]
        Region 4: I/O ports at 2060 [size=16]
        Region 5: I/O ports at ffe0 [size=16]
        Capabilities: <access denied>
        Kernel driver in use: ata_piix
  00: 86 80 01 1c 07 00 b0 02 05 8f 01 01 00 00 00 00
  10: 69 21 00 00 7d 21 00 00 61 21 00 00 79 21 00 00
  20: 61 20 00 00 e1 ff 00 00 00 00 00 00 86 80 70 72
  30: 00 00 00 00 70 00 00 00 00 00 00 00 0b 02 00 00

and I do think that resume used to be faster in v3.2 than it is even
with your patch. But maybe that's some rose-colored glasses.

I'll recompile an old kernel to check.

               Linus
