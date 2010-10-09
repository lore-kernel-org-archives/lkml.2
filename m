Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938Ab0JIMJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 08:09:58 -0400
Received: from www.tglx.de ([62.245.132.106]:57231 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab0JIMJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 08:09:56 -0400
Date: Sat, 9 Oct 2010 14:08:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Grant Likely <grant.likely@secretlab.ca>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/47] Sparse irq rework
In-Reply-To: <4CB014F5.5080209@kernel.org>
Message-ID: <alpine.LFD.2.00.1010091407170.2640@localhost6.localdomain6>
References: <20100930221351.682772535@linutronix.de> <20101003112312.GB9844@angua.secretlab.ca> <20101003112920.GB32736@n2100.arm.linux.org.uk> <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com> <alpine.LFD.2.00.1010031544340.14550@localhost6.localdomain6>
 <alpine.LFD.2.00.1010051219580.2556@localhost6.localdomain6> <4CACFC23.4080504@kernel.org> <alpine.LFD.2.00.1010070050410.17015@localhost6.localdomain6> <4CAD082B.40908@kernel.org> <4CAD1154.3080403@kernel.org> <alpine.LFD.2.00.1010070559480.17015@localhost6.localdomain6>
 <4CAD4EC3.5060809@kernel.org> <alpine.LFD.2.00.1010082346310.13094@localhost6.localdomain6> <alpine.LFD.2.00.1010082351450.13094@localhost6.localdomain6> <4CAFEEFA.1070000@kernel.org> <4CB00122.3030301@kernel.org> <alpine.LFD.2.00.1010090829150.13094@localhost6.localdomain6>
 <4CB014F5.5080209@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Oct 2010, Yinghai Lu wrote:
> On 10/08/2010 11:34 PM, Thomas Gleixner wrote:
> >>  	irq = pin_2_irq(idx, apic_id, pin);
> >>  
> >> +	/* only handle fall out from setup_IO_APIC_irqs() */
> > 
> > What's the fallout ? And why are we coming here in the first place
> > when the irq is < 16 ?
> 
> setup_IO_APIC_irqs only handle apic_id == 0 or apic_id > 0 but irq < 16 via acpi override.
> 
> it seems IBM's system have apic_id == 1, and sci irq is using 30.
> 
> so at that time add that setup_IO_APIC_irq_extra() to workaround it.
> but it seems we set that two time when irq < 16.

Hmm. Ok. Thanks for figuring it out.

Thanks,

	tglx
