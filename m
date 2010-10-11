Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0JKLfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 07:35:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:46616 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072Ab0JKLfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 07:35:37 -0400
Subject: Re: [patch 00/47] Sparse irq rework
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mundt <lethal@linux-sh.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <alpine.LFD.2.00.1010110953420.2909@localhost6.localdomain6>
References: <20100930221351.682772535@linutronix.de>
	 <20101003112312.GB9844@angua.secretlab.ca>
	 <20101003112920.GB32736@n2100.arm.linux.org.uk>
	 <AANLkTingVuhgdaLZ8U3bM+F2vZJ_kScwKqNtHW=g6DcH@mail.gmail.com>
	 <alpine.LFD.2.00.1010031544340.14550@localhost6.localdomain6>
	 <alpine.LFD.2.00.1010051219580.2556@localhost6.localdomain6>
	 <4CACFC23.4080504@kernel.org>
	 <alpine.LFD.2.00.1010070050410.17015@localhost6.localdomain6>
	 <4CAD082B.40908@kernel.org> <4CAD1154.3080403@kernel.org>
	 <alpine.LFD.2.00.1010070559480.17015@localhost6.localdomain6>
	 <4CAD4EC3.5060809@kernel.org>
	 <alpine.LFD.2.00.1010082346310.13094@localhost6.localdomain6>
	 <alpine.LFD.2.00.1010082351450.13094@localhost6.localdomain6>
	 <4CAFEEFA.1070000@kernel.org> <4CB00122.3030301@kernel.org>
	 <alpine.LFD.2.00.1010090829150.13094@localhost6.localdomain6>
	 <4CB014F5.5080209@kernel.org>
	 <alpine.LFD.2.00.1010101130160.2413@localhost6.localdomain6>
	 <4CB28988.4090207@kernel.org>
	 <alpine.LFD.2.00.1010110953420.2909@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 22:34:46 +1100
Message-ID: <1286796886.5220.4.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hmm, that's probably a problem for all legacy interrupts which are
> never torn down once they are set up. And we set them all up during
> early boot.
> 
> So either we special case the legacy area or remove the warning
> alltogether.
> 
> Another option I discussed with Suresh recently is to remove the
> allocator in intr_remapping.c and just embedd irq_2_iommu into
> irq_cfg.

Just in case that's of use, on powerpc, we just special case the legacy
range. It's keep un-requestable unless somebody comes and explicitely
claims it (using a special flag for our virq scheme, typically only 8259
does it for us) and then we get 1:1 all pre-allocated and mostly
immutable.

Cheers,
Ben.

