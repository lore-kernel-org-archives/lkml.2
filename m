Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab1GYHyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 03:54:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46151 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab1GYHx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 03:53:58 -0400
Date: Mon, 25 Jul 2011 09:53:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Jan Kiszka <jan.kiszka@web.de>, torvalds@linux-foundation.org,
        avi@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gorcunov@gmail.com,
        levinsasha928@gmail.com, asias.hejun@gmail.com,
        prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725075305.GA32294@elte.hu>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
 <4E2CA6DE.4040900@web.de>
 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
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


* Pekka Enberg <penberg@kernel.org> wrote:

> On Mon, Jul 25, 2011 at 2:12 AM, Jan Kiszka <jan.kiszka@web.de> wrote:
> > That said, I definitely appreciate the bug fixes as well as code and
> > documentation improvements for KVM that originate from this effort! I'm
> > just not convinced that writing a new userland and merging it into the
> > kernel is the most efficient way to achieve that.
> 
> Just to make this crystal clear for everyone: if it weren't for 
> tools/kvm, I wouldn't be hacking on KVM at all. I've looked at Qemu 
> in the past (and a lot recently!) and I simply don't see myself 
> contributing to it, sorry. So 'most efficient' or not, I think 
> tools/kvm is a net win for Linux and KVM in general.

Same here - in fact i first asked Qemu to be put into tools/qemu/ so 
that it all becomes more hackable and more usable - that suggestion 
was rebuked very strongly.

So i wanted to have a lightweight tool that allows me to test KVM and 
tools/kvm/ does that very nicely: i type './kvm run' and i can test a 
native bzImage (which has some virtualization options enabled as 
well) on the _host_ distro i am running, booting to a text shell 
prompt.

I can do that without downloading any (inevitably outdated) 
virtualization images or maintaining my own ones. Maintaining host 
userspace is more than enough for me.

So, since we already have the lguest tool in the kernel tree, why 
cannot we have the much more capable tools/kvm/ in the tree?

So while it is the Qemu folks' right to oppose tools/qemu/, i don't 
see why they are opposing tools/kvm/ ...

Wrt. integration with lguest - this is a new argument that was not 
brought up before (i wish people would not come up with new 
requirements on the day of the pull request) - i don't see how it's 
relevant really: lguest was designed for legacy CPUs and tools/kvm/ 
is precisely about being simple and not doing legacy stuff.

If then Qemu should be the project that integrates lguest. Is anyone 
on the Qemu side looking at lguest integration?

Thanks,

	Ingo
