Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab1GYJmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 05:42:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35889 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab1GYJm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 05:42:28 -0400
Date: Mon, 25 Jul 2011 11:41:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Graf <agraf@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725094136.GE28787@elte.hu>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
 <4E2CA6DE.4040900@web.de>
 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
 <20110725075305.GA32294@elte.hu>
 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
 <20110725085426.GA28787@elte.hu>
 <C80CB058-38B3-4EA4-996F-4585F521415C@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C80CB058-38B3-4EA4-996F-4585F521415C@suse.de>
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


* Alexander Graf <agraf@suse.de> wrote:

> On 25.07.2011, at 10:54, Ingo Molnar wrote:
> 
> > 
> > * Alexander Graf <agraf@suse.de> wrote:
> > 
> >> On 25.07.2011, at 09:53, Ingo Molnar wrote:
> >> 
> >>> 
> >>> * Pekka Enberg <penberg@kernel.org> wrote:
> >>> 
> >>>> On Mon, Jul 25, 2011 at 2:12 AM, Jan Kiszka <jan.kiszka@web.de> wrote:
> >>>>> 
> >>>>> That said, I definitely appreciate the bug fixes as well as 
> >>>>> code and documentation improvements for KVM that originate from 
> >>>>> this effort! I'm just not convinced that writing a new userland 
> >>>>> and merging it into the kernel is the most efficient way to 
> >>>>> achieve that.
> >>>> 
> >>>> Just to make this crystal clear for everyone: if it weren't for 
> >>>> tools/kvm, I wouldn't be hacking on KVM at all. I've looked at 
> >>>> Qemu in the past (and a lot recently!) and I simply don't see 
> >>>> myself contributing to it, sorry. So 'most efficient' or not, I 
> >>>> think tools/kvm is a net win for Linux and KVM in general.
> >>> 
> >>> Same here - in fact i first asked Qemu to be put into tools/qemu/ 
> >>> so that it all becomes more hackable and more usable - that 
> >>> suggestion was rebuked very strongly.
> >> 
> >> So instead of thinking a bit and trying to realize that there might 
> >> be a reason people don't want all their user space in the kernel 
> >> tree you go ahead and start your own crusade of creating a new user 
> >> space. Great. That's how I always hoped Linux would be :(.
> > 
> > Not "all their user space" but the ones that are tightly 
> > integrated with the kernel to begin with. How hard is that 
> > concept to understand?
> 
> It's very hard to understand. It's similar to religion - I could 
> easily apply your point to every reasonably low-level user space 
> project out there. X for example. X needs to interact with KMS and 
> DRI and whatdoiknow. So it'd be a perfect fit to pull into tools/, 
> no?

If the graphics folks feel comfortable with that approach then yes, i 
think graphics would be a good example as well - in my experience a 
lot of the user-space pain related to graphics development comes from 
ugly version friction between various graphics components, and all 
the APIs are pretty fluid and heavily developed - which is easier to 
do within a single code repository.

But if the Xorg/graphics folks want it separate it's their decision 
and they've said it in the past that they like the current 
modularization.

If someone comes with tools/X11/ that actually *works* and provides a 
usable X11 replacement i sure would try it out and would likely 
contribute to it.

Basic infrastructure and tooling - many projects could apply but the 
most obvious choices are ones that relate to and depend on the 
kernel.

Browsers, email clients, GIMP, games, LibreOffice, not so much.

There's no clear line but that's not a problem - there are seldom any 
clear lines in life. It's a case by case issue and very much depends 
on the attributes of the project and the preferences of the 
developers who are driving it.

I can tell you my first hand experience: for tools/perf/ and 
tools/kvm/ it was highly beneficial to be developed in the kernel 
repo.

I don't see how you can validly bring religion into this discussion.

> > Virtualization is very tightly bound to the kernel, like it or 
> > not.
> 
> I don't see why. The whole point of virtualization is to model 
> simple, with KVM preferably even very-close-to-real-hardware 
> interfaces that allow you to keep things separate.

Look at tools/kvm/ - i cannot do anything useful without a Linux 
kernel under it. It's as deeply bound to the Linux kernel as it gets.

Then look at the actual drivers and interfaces within tools/kvm/. 
It's using the same symbols and conventions for 'guest' and 'host' 
side.

Check out tools/kvm/hw/i8042.c and match it up with 
include/linux/serio.h and drivers/input/serio/i8042.c - you can 
literally walk from one side to the other and understand how guest 
and host are tightly related not just functionality but also 
implementation wise.

This is how Qemu should be doing it as well btw., to ease the 
debugging of host/guest interaction bugs and to ease development.

> > So is profiling, power management and a few other things.
> 
> I'm also failing to see the reasoning here TBH.

You need to quote the full argument to see the reason in it:

> > Virtualization is very tightly bound to the kernel, like it or 
> > not. So is profiling, power management and a few other things.

It's a very simple point and observation: tools which integrate to 
the kernel so that they wouldnt even run on another kernel obviously 
are very natural to develop in tools/.

Thanks,

	Ingo
