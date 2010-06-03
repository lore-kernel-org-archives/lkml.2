Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab0FCJ0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:26:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43493 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632Ab0FCJ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:26:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=psq3gtMuZETmDNnBQTLFIKfkVNWCPQ89SzQIbJn1tgULTLsR0Ty11D0f9GMV2h+AlB
         b5NQIy8koRz4QgGllHmxOW+Xl8DrZkonMI1g1Eu8FMlZctjeeBN4iFF7VENZLcNcVN6P
         Uay6oTxSF/+zWpA9Xw0Fk4cgaJDK5NDvATAzc=
Message-ID: <4C077548.90203@gmail.com>
Date: Thu, 03 Jun 2010 11:26:32 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100527 SUSE/3.1rc1-3.3 Thunderbird/3.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: cpqphp: NULL ptr deref in cpqhpc_probe
References: <4C0774C6.4090000@suse.cz>
In-Reply-To: <4C0774C6.4090000@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2010 11:24 AM, Jiri Slaby wrote:
> we have a system where there is a pci hotplug class device to be handled
> by cpqphp, but it is not a bridge. But in cpqhpc_probe there is:
> struct pci_bus *bus;
> ...
> bus = pdev->subordinate;
> ...
> bus->max_bus_speed = PCI_SPEED_66MHz_PCIX;
> 
> But as it is not a bridge, subordinate is NULL and the kernel crashes.
> 
> Any idea what would be a correct fix here?
> 
> The bugzilla entry is at:
> https://bugzilla.novell.com/show_bug.cgi?id=609338

I forgot to attach the device information:
00:0b.0 PCI Hot-plug controller: Compaq Computer Corporation PCI Hotplug
Controller (rev 11)
	Subsystem: Compaq Computer Corporation Device a2f8
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 15
	Region 0: Memory at f7ad0000 (32-bit, non-prefetchable) [size=256]

