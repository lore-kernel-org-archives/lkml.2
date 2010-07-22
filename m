Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab0GVWCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:02:14 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:35420 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab0GVWCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:02:10 -0400
Date: Thu, 22 Jul 2010 18:01:59 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Iain <selsinork@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "Yu, Luming" <luming.yu@intel.com>,
        Philip Langdale <philipl@overt.org>, Jeff Garrett <jeff@jgarrett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "venki@google.com" <venki@google.com>
Subject: Re: [PATCH] ACPI: make acpi_idle Nehalem-aware
In-reply-to: <4C48B730.30708@gmail.com>
Message-id: <alpine.LFD.2.00.1007221751550.13016@localhost.localdomain>
References: <20100427124703.GA16706@jgarrett.org>
 <alpine.LFD.2.00.1004301218280.2489@sony>
 <20100430174447.GA14889@srcf.ucam.org>
 <d7f2dd35a4361e5156079278543769a0@localhost>
 <alpine.LFD.2.00.1005250125590.20648@localhost.localdomain>
 <CE761E84DADF2947A4AF22FB8D97A4731E0366B5@shsmsx501.ccr.corp.intel.com>
 <20100525124325.GC7876@srcf.ucam.org>
 <alpine.LFD.2.00.1005251114420.4114@localhost.localdomain>
 <20100525185507.GA15997@srcf.ucam.org>
 <alpine.LFD.2.00.1007211729550.409@localhost.localdomain>
 <20100722074750.GA22520@one.firstfloor.org>
 <alpine.LFD.2.00.1007221153120.3164@localhost.localdomain>
 <4C48B730.30708@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm curious as to why you see a problem with the DL380G6 as the one I have
> here happily sits in C6 when idle.

yay!

> your turbostat util shows:
> 
>  CPU  GHz  TSC   %c0    %c1    %c3    %c6   %pc3   %pc6
>  avg 1.64 2.27   0.16   0.12   0.00  99.71   0.00  90.15


> Looking at the bug 15886, the Access Size 0x03 entries you mentioned are all
> 0x01 on this system. I've also uploaded the acpidump from this DL380G6 to that
> bug so that you can check I've not just looked in the wrong place.

You read it correctly, your BIOS does not request BM_STS, mjg59's does.

> Did the first acpidump come from a system with the 'HP Power Regulator'
> setting in the bios set to OS Control mode ?  My system is set this way and it
> seems to work as expected.

I expect that is to enable PCC, which would change P-states,
but unlikely would have an effect on C-states.
If you can try it both ways that might be good to know.
(include powertop display once again)
Of course, the default setting is what 99% of customers use...

> The other settings for this option appear to be designed to override OS power
> management controls, for example the description of the 'Static High
> Performance' option suggests it'll somehow force the CPU to operate in the
> highest performance mode all of the time: "HP Static High Performance Mode:
> Processors will run in their maximum power/performance state at all times
> regardless of the OS power management policy".

This is BIOS writer "value add".
Unclear how it migh be an improvement over what Linux has been shipping 
for years.

> If this does turn out to be as simple as a bios setting, should we really be
> trying to workaround what may be a legitimate decision by the servers admin ?

Ideally we will do exactly as the BIOS requests.
However, somtimes what they request makes lots of sense
on some version of Windows, and may make less sense
when running Linux.

Please upload the output from dmidecode to the bug report.
I am hopeful that you have a current BIOS and that
Matthew may have an pre-production BIOS.

thanks,
Len Brown, Intel Open Source Technology Center



