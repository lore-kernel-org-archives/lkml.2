Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab2AWGYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 01:24:12 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:51828 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab2AWGYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 01:24:12 -0500
Date: Mon, 23 Jan 2012 06:24:09 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: john stultz <johnstul@us.ibm.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Clark Williams <williams@redhat.com>,
        Nivedita Singhvi <niv@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
        vosburgh@us.ibm.com
Subject: Re: Lapic vector priorites
In-Reply-To: <1327297111.4129.27.camel@work-vm>
Message-ID: <alpine.LFD.2.00.1201230609560.22644@eddie.linux-mips.org>
References: <1327297111.4129.27.camel@work-vm>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jan 2012, john stultz wrote:

> I'm really not that familiar with the lapic code, but reading over some
> of the documentation I could find through searches, and then looking at
> the lapic vector layout in the kernel, I'm now a little curious.
> 
> >From what I've read the irq priority is set by the vector, where 0x0 is
> the highest and 0xFF is the lowest.
> 
> In irq_vectors.h I see:
> #define NMI_VECTOR			0x02
> #define MCE_VECTOR			0x12

 Both these vectors are hardwired internally in the CPU and irrelevant to 
the APIC interrupt priority levels as these apply to ordinary interrupts 
only.  For these the higher the vector value, the higher the priority (I 
won't get into the gory details, my memory has already faded about that 
and I'd have to resort to documentation to avoid confusion).

 The MCE is actually a processor exception and as such does not go through 
the APIC at all.  It's either signalled internally by the CPU (to record 
an internal malfunction) or via an external signal (to raise a bus error 
or a similar event).

 The NMI is the non-maskable interrupt and is driven by the local APIC on 
a separate processor's internal line (back in the 1990s where discrete 
local APICs were used this would actually be a separate board signal to 
the CPU) and it's the CPU that gives this line the priority above an 
ordinary interrupt that may be asserted at the same time.  For an NMI the 
CPU does not drive an INTA cycle (again, internally for modern processors) 
on its bus which the local APIC would respond with an interrupt vector to.

 I hope this helps.

  Maciej
