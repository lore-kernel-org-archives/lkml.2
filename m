Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab0GWVmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 17:42:33 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42607 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab0GWVmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 17:42:32 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C4A0CAF.9060308@s5r6.in-berlin.de>
Date: Fri, 23 Jul 2010 23:42:07 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
CC: Jay Fenlason <fenlason@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.35-rc6 to 2.6.32.16: JuJu firewire issues
References: <4C49A291.20001@ribosome.natur.cuni.cz> <20100723180807.GA32319@redhat.com> <4C49E1A2.7050606@ribosome.natur.cuni.cz> <20100723192646.GB32319@redhat.com> <4C49F955.1040308@ribosome.natur.cuni.cz>
In-Reply-To: <4C49F955.1040308@ribosome.natur.cuni.cz>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Mokrejs wrote at LKML:
> Hi Jay,
>   I removed the old firewire modules from kernel .config and recompiled&reinstalled
> the kernel file and modules on compiuter A, and disabled the firewire_sbp2 on host B.
>   I have power problems with the drive when on firewire, though. It seems the desktop
> PC (ASUS P5K WS 1.0004) is not able to feed the WD 1.0TB 2.5 5200rpm" drive.

Although it should, unless if the ASUS motherboard is miswired.  A
standards compliant bus power provider must be able to supply at least
1.5 A.  Most PCs wire their FireWir ports up to 12 Volts, which gives
you at least 18 Watts.  You can driver several of these WD drives off that.

> I tried
> the firewire ports on the front of the box as well those from the motherboard.

Front panel connectors may be unreliable.  Often the connections from
mortherboard to front panel are cheap and outside the IEEE 1394
electrical specification.

> Even,
> plugged in the USB power "jack", no luck. If I use the USB port + USB power it works
> fine. I just unplugged the device after not being able to even run "fdisk /dev/sdh".
>   At the moment I have screwed superblock on the filesystem and will have to re-start
> from scratch. The attached dmesg talks about "Device offlined - not ready after error
> recovery" but I hope this is a temporary issue, and I just disconnected the device
> at the very end.
>   BTW, some driver is not ACPI compliant according to dmesg.
> 
>   The chip in the external IcyBox IB-250StUE-B is JMicron JMB 353 doing the USB+FireWire+SATA
> work for the 2.5" WD drive.
> Martin

Oh, I haven't heard of that chip before.  So far I was only aware of
PCIe--FireWire chips from JMicron.  PCIe--FireWire chips are of course
entirely different beasts than SATA--FireWire chips, but those other
FireWire offerings from JMicron do not inspire confidence.

Your dmesg shows multiple bus resets and one of the three nodes
disappearing from the bus from time to time.  This points to a probelm
at the physical layer (i.e. highly unreliable hardware) which
fundamentally cannot be solved by software.
-- 
Stefan Richter
-=====-==-=- -=== =-===
http://arcgraph.de/sr/
