Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab0J0GY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 02:24:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53344 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab0J0GYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 02:24:23 -0400
Date: Wed, 27 Oct 2010 08:23:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Bob Picco <bpicco@redhat.com>,
        Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Stefan Becker <chemobejk@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
        Fabrice Bellet <fabrice@bellet.info>, Yinghai Lu <yinghai@kernel.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v5 9/9] x86: allocate space within a region top-down
Message-ID: <20101027062354.GA6854@elte.hu>
References: <20101026214033.29808.15272.stgit@bob.kio>
 <20101026214154.29808.58672.stgit@bob.kio>
 <20101026153455.0fe4847f@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101026153455.0fe4847f@jbarnes-desktop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Tue, 26 Oct 2010 15:41:54 -0600
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > Request that allocate_resource() use available space from high addresses first, 
> > rather than the default of using low addresses first.
> > 
> > The most common place this makes a difference is when we move or assign new PCI 
> > device resources.  Low addresses are generally scarce, so it's better to use 
> > high addresses when possible.  This follows Windows practice for PCI allocation.
> > 
> > Reference: https://bugzilla.kernel.org/show_bug.cgi?id=16228#c42
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > ---
> 
> Ok, applied this version to -next.  It's been going through distros and lots of 
> testing despite a lack of recent coverage in PCI -next, so I'm planning to send it 
> to Linus this week.  We probably won't catch much more until it hits his tree 
> anyway...

It also appears to fix a serious compatibility bug (and a v2.6.34 regression), so 
even without extensive distro testing it's wise to push this upstream ASAP IMHO ...

Thanks,

	Ingo
