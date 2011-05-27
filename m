Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab1E0JhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:37:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38559 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab1E0Jg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:36:59 -0400
Date: Fri, 27 May 2011 11:36:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Valdis.Kletnieks@vt.edu, Dan Rosenberg <drosenberg@vsecurity.com>,
        Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110527093645.GH21386@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <20110526200121.GG29496@redhat.com>
 <26081.1306440965@turing-police.cc.vt.edu>
 <20110526203108.GJ29496@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526203108.GJ29496@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vivek Goyal <vgoyal@redhat.com> wrote:

> On Thu, May 26, 2011 at 04:16:05PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 26 May 2011 16:01:21 EDT, Vivek Goyal said:
> > 
> > > Also randomization of kernel load address at run time will probably have
> > > some issues with crashkernel=X@Y address syntax. So far user knew what
> > > address first kernel is booting from and user could speicy where to 
> > > reserve memory. Now it might happen that user specified some memory
> > > to reserve and kernel decided to occupy that space resulting in failed
> > > memory reservation for crash kernel.
> > 
> > That is however fixable - the randomizer just needs to make sure it doesn't
> > overlay the crashkernel= space, and the crashkernel needs to be started with a
> > 'norandomize' parameter.
> 
> That can be done but at the same time if kernel does not find any suitable
> range to boot from, it should override crashkernel=X@Y settings and fail
> crash memory reservation.
> 
> I guess with randomize space thing a more suitable crash kernel command
> line will be crashkernel=X where kernel decides the base address for
> second kernel depending on availability.
> 
> > If your threat model includes attacks on the
> > crashkernel that randomizing will help with, you got bigger problems. ;)
> > 
> 
> :-) I think norandomize for kdump kernel should be just fine.

Dan, please always generate a very clear printk when randomization is 
off - if we implement everything correctly then it will be impossible 
for even the admin to determine whether there's kernel image 
randomization going on on a system! :-)

Btw., systems with signed modules and with an inability for even root 
to break into the kernel probably want to disable the pagetable 
dumper in debugfs, that will show the exact location of the kernel 
image.

(Btw., please also check that unprivileged users cannot read that 
file.)

Thanks,

	Ingo
