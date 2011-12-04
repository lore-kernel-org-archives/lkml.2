Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab1LDOIL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 09:08:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64193 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab1LDOIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 09:08:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAPRPZsBdnrProsTaSYnMKi6Q3dSsP9nYkw0CKnmb-BrmJxBivw@mail.gmail.com>
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com>
	<20111130154445.GA27198@gere.osrc.amd.com>
	<1E8B869C0C6913418421A406C094DF7C0205358F@sshaexmb1.amd.com>
	<CAPRPZsAL=xUCjTKaSgq117zppvZS0S7fHB0Ebk-JqXvV1vTPCQ@mail.gmail.com>
	<4EDB6C10.10102@ladisch.de>
	<CAPRPZsAc8wr_2KsRi3LnGi4ic-CzrFLbRvQfkrXckH--vaLkVQ@mail.gmail.com>
	<CAPRPZsBdnrProsTaSYnMKi6Q3dSsP9nYkw0CKnmb-BrmJxBivw@mail.gmail.com>
Date: Sun, 4 Dec 2011 15:08:09 +0100
Message-ID: <CAPRPZsBO_hvAv8o0vKh7XuE+RiEunETaxaPsmdm5yPe5YvOdPA@mail.gmail.com>
Subject: Re: Unhandled IRQs on AMD E-450
From: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens,

FYI,

> In theory, lspci's "Status: ... INTx+" shows an active interrupt line.

I have succeeded in catching a lspci on the SATA controller with INTx+
while IRQ 19 is disabled.


00:11.0 SATA controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 SATA
Controller [AHCI mode] (rev 40) (prog-if 01 [AHCI 1.0])
        Subsystem: ASUSTeK Computer Inc. Device 8496
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
        Latency: 32
        Interrupt: pin A routed to IRQ 19
        Region 0: I/O ports at f140 [size=8]
        Region 1: I/O ports at f130 [size=4]
        Region 2: I/O ports at f120 [size=8]
        Region 3: I/O ports at f110 [size=4]
        Region 4: I/O ports at f100 [size=16]
        Region 5: Memory at feb4f000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [70] SATA HBA v1.0 InCfgSpace
        Capabilities: [a4] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: ahci
        Kernel modules: ahci


The fact that the next lspci's showed INTx- shows that its pin is
definitely not stuck, does it not ? When I do e.g.

$ du -h -x --max-depth=1

in a second terminal, it gets the line nicely back to INTx+ due to
outstanding SATA commands. Cancelling the above du command (would
otherwise take ages to complete) results in INTx-.

Continuing with your patch...


J.
