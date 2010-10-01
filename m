Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab0JAUqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 16:46:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:48842 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830Ab0JAUqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 16:46:49 -0400
Subject: Re: [patch 46/47] powerpc: Use new irq allocator
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <alpine.LFD.2.00.1010011504380.2416@localhost6.localdomain6>
References: <20100930221351.682772535@linutronix.de>
	 <20100930221743.014571381@linutronix.de> <1285893737.2463.4.camel@pasglop>
	 <alpine.LFD.2.00.1010011504380.2416@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Oct 2010 06:46:13 +1000
Message-ID: <1285965973.2463.129.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 15:07 +0200, Thomas Gleixner wrote:
> On Fri, 1 Oct 2010, Benjamin Herrenschmidt wrote:
> 
> > On Thu, 2010-09-30 at 23:18 +0000, Thomas Gleixner wrote:
> > > plain text document attachment (powerpc-use-new-allocator.patch)
> > > Use the new functions and free the descriptor when the virq is
> > > destroyed.
> > 
> > Looks ok as a first pass, but we should go further and replace the
> > allocator we have in powerpc to use yours instead.
> > 
> > Then I should get rid of my big irq_map that maps virq to HW number &
> > domain pointers and instead put those in the irq data. Any objection to
> > me sticking some archdata there for that purpose ?
> 
> No, though if we can avoid another void pointer and have a sensible
> data structure for it would be nice.

Yes, I'm thinking about an arch defined structure like I did for struct
device.

Cheers,
Ben.

> > That would make things much cleaner and in fact move one large step
> > toward being able to make powerpc virq scheme generic, which seems to be
> > a good idea from what I've heard :-)
> 
> Yep.
> 
> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


