Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab1GYKEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:04:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35211 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab1GYKED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:04:03 -0400
Date: Mon, 25 Jul 2011 12:03:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Alexander Graf <agraf@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Jan Kiszka <jan.kiszka@web.de>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725100311.GH28787@elte.hu>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
 <4E2CA6DE.4040900@web.de>
 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
 <20110725075305.GA32294@elte.hu>
 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
 <20110725085426.GA28787@elte.hu>
 <C80CB058-38B3-4EA4-996F-4585F521415C@suse.de>
 <20110725094136.GE28787@elte.hu>
 <4E2D3BF1.7070406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2D3BF1.7070406@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Avi Kivity <avi@redhat.com> wrote:

> On 07/25/2011 12:41 PM, Ingo Molnar wrote:

> > Look at tools/kvm/ - i cannot do anything useful without a Linux 
> > kernel under it. It's as deeply bound to the Linux kernel as it 
> > gets.
> 
> The actual code that interacts with the kernel is pretty small, and 
> will grow smaller (as a fraction) in time.

Look at the example i have given in my other mail, conceptual 
interaction goes beyond the strict KVM (and hardware) ABIs themselves 
- for every guest side driver there's a host side piece of 
functionality.

What we found is that there's real benefits from tools/kvm/hw/i8042.c 
using the same conventions and constants as 
drivers/input/serio/i8042.c.

The two pieces of code are obviously independent ABI-wise - but to 
developers working on both sides of the fence it's very useful to 
have the code look similar and familiar.

Some other pieces of code share library functionality between the 
kernel and tools/kvm/.

> > Then look at the actual drivers and interfaces within tools/kvm/. 
> > It's using the same symbols and conventions for 'guest' and 
> > 'host' side.
> >
> > Check out tools/kvm/hw/i8042.c and match it up with 
> > include/linux/serio.h and drivers/input/serio/i8042.c - you can 
> > literally walk from one side to the other and understand how 
> > guest and host are tightly related not just functionality but 
> > also implementation wise.
> >
> > This is how Qemu should be doing it as well btw., to ease the 
> > debugging of host/guest interaction bugs and to ease development.
> 
> No. That ties the guest and host interfaces together. [...]

Why would it tie the interfaces together? For a guest and host driver 
to be written in the same familiar conventions is useful for 
debugging and development easier but does not prevent both of those 
pieces to implement a precise interface. (Especially since in the 
i8042 case the host driver is used with real hardware as well.)

> [...]  If you change the guest to use a feature you didn't 
> implement previously in the host, it's suddenly broken when 
> virtualized.
> 
> The right thing is to implement the hardware interface exactly per 
> spec, and ignore the guest(s) completely except for testing and 
> performance.

You can certainly do that too - and nothing prevents from the guest 
and host driver to look and feel similar.

But note that for many of these things there no such thing as a 
'hardware spec' that describes all the details and quirks - what we 
have are host PC drivers that have been implemented via many cycles 
of trial and error. That's especially true of i8042, the example i 
have given.

Thanks,

	Ingo
