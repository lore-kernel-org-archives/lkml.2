Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab1IIVnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 17:43:35 -0400
Received: from mxin.vub.ac.be ([134.184.129.112]:10021 "EHLO mxin.vub.ac.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1IIVne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 17:43:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEGANB7ak6GuBhX/2dsb2JhbABCFoQ/nQSHM4FSAQEEASMEUgULCxoCJgICVwYTh3YCAqVokhWBLIQxgREEmD0QjAc
Subject: Re: [E1000-devel] e1000e: NIC not working (after resume?)
From: Frederik Himpe <fhimpe@telenet.be>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Cc: e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Fri, 09 Sep 2011 23:43:32 +0200
References: <j4d428$ndo$1@dough.gmane.org> <j4d569$ndo$2@dough.gmane.org>
	 <CAEuXFEz5si7tOxcpkmnVTuHovOm=8c+eXHGp+CtGNj9b=VjLeA@mail.gmail.com>
Organization: Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2- 
Content-Transfer-Encoding: 7bit
Message-ID: <1315604613.16869.29.camel@defected>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 23:05 +0200, Frederik Himpe wrote:

> Full syslog (221 KB) is at
> http://artipc10.vub.ac.be/~frederik/e1000e/syslog
> 
> This is what happened:
> * 21:33:11: cold boot, network cable plugged in, network working fine
> * 21:35:24: start suspend to ram
> * 21:35:40: resume system, e1000e network working fine (however, wlan
> now refuses to connect, but I have not investigated that, not sure if
> whether this might be related or not)
> * 21:52:44: logs are filled up with an endless loop of these messages (I
> think I disconnected the network cable at that time:
> 
> Sep  9 21:52:44 defected kernel: [ 1188.440061] ehci_hcd 0000:00:1d.7: BAR 0: set to [mem 0xfed1c000-0xfed1c3ff] (PCI address [0xfed1c000-0xfed1c3ff])
> Sep  9 21:52:44 defected kernel: [ 1188.440097] ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x104)
> Sep  9 21:52:44 defected kernel: [ 1188.440137] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
> Sep  9 21:52:44 defected kernel: [ 1188.447422] ehci_hcd 0000:00:1d.7: PME# disabled
> Sep  9 21:52:44 defected kernel: [ 1188.447446] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> Sep  9 21:52:44 defected kernel: [ 1188.447461] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> Sep  9 21:52:44 defected kernel: [ 1188.447519] ehci_hcd 0000:00:1d.7: PCI INT A disabled
> Sep  9 21:52:44 defected kernel: [ 1188.447588] ehci_hcd 0000:00:1d.7: PME# enabled

Reproduced this again, and the above loop happens when reconnecting the
network cable.

So when network is working fine and I disconnetc the cable, this appears
in the logs:

Sep  9 23:35:55 defected kernel: [ 5931.492189] e1000e: eth0 NIC Link is Down
Sep  9 23:35:55 defected kernel: [ 5931.662818] e1000e 0000:00:19.0: PCI INT A disabled
Sep  9 23:35:55 defected kernel: [ 5931.662836] e1000e 0000:00:19.0: PME# enabled
Sep  9 23:35:55 defected kernel: [ 5931.676060] ehci_hcd 0000:00:1d.7: BAR 0: set to [mem 0xfed1c000-0xfed1c3ff] (PCI address [0xfed1c000-0xfed1c3ff])
Sep  9 23:35:55 defected kernel: [ 5931.676093] ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x104)
Sep  9 23:35:55 defected kernel: [ 5931.676132] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
Sep  9 23:35:55 defected kernel: [ 5931.683253] ehci_hcd 0000:00:1d.7: PME# disabled
Sep  9 23:35:55 defected kernel: [ 5931.683276] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Sep  9 23:35:55 defected kernel: [ 5931.683290] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Sep  9 23:35:55 defected kernel: [ 5931.683350] ehci_hcd 0000:00:1d.7: PCI INT A disabled
Sep  9 23:35:55 defected kernel: [ 5931.683412] ehci_hcd 0000:00:1d.7: PME# enabled
Sep  9 23:35:55 defected kernel: [ 5931.704067] ehci_hcd 0000:00:1a.7: BAR 0: set to [mem 0xfed1c400-0xfed1c7ff] (PCI address [0xfed1c400-0xfed1c7ff])
Sep  9 23:35:55 defected kernel: [ 5931.704099] ehci_hcd 0000:00:1a.7: restoring config space at offset 0xf (was 0x300, writing 0x30a)
Sep  9 23:35:55 defected kernel: [ 5931.704137] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900102)
Sep  9 23:35:55 defected kernel: [ 5931.711840] ehci_hcd 0000:00:1a.7: PME# disabled
Sep  9 23:35:55 defected kernel: [ 5931.711863] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
Sep  9 23:35:55 defected kernel: [ 5931.711877] ehci_hcd 0000:00:1a.7: setting latency timer to 64
Sep  9 23:35:55 defected kernel: [ 5931.711948] ehci_hcd 0000:00:1a.7: PCI INT C disabled
Sep  9 23:35:55 defected kernel: [ 5931.712045] ehci_hcd 0000:00:1a.7: PME# enabled

When I reconnect the cable again one minute later, there is no
information anymore about e1000e in the kernel logs and ehci_hcd ends up
in the endless loop.

-- 
Frederik Himpe <fhimpe@telenet.be>

