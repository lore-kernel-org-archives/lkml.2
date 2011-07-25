Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab1GYJmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 05:42:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab1GYJmN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 05:42:13 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20110725092656.GD28787@elte.hu>
Date: Mon, 25 Jul 2011 11:42:02 +0200
Cc: Pekka Enberg <penberg@kernel.org>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <68C2AB77-AA91-4B21-A321-2DB4EF8121C1@suse.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger> <4E2CA6DE.4040900@web.de> <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com> <20110725075305.GA32294@elte.hu> <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de> <CAOJsxLHGgpNrHpfnHzD-aOJakE9q_4ym51_AYQHaj+waEZtSuw@mail.gmail.com> <ED2ECD82-2B14-45FF-AA61-AB26B377B626@suse.de> <CAOJsxLFDzSg55u92b6Qgvqn1yjaShYG_Bgdkzy19aBrzxo7FqA@mail.gmail.com> <20110725092656.GD28787@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25.07.2011, at 11:26, Ingo Molnar wrote:

> 
> * Pekka Enberg <penberg@kernel.org> wrote:
> 
>> [ I thought the 'native Linux' part in 'native Linux KVM tool' was 
>> a dead giveaway, really. ]
>> 
>> Now if people want to support other operating systems, that's cool 
>> and I'm happy to help out where I can. But I don't understand why 
>> people keep bringing non-Linux OSs as an argument for not merging 
>> tools/kvm into the Linux kernel tree. I mean really, did someone 
>> actually expect that a Linux kernel developer spends his weekends 
>> improving the state of Windows virtualization?
>> 
>> And don't get this the wrong way either, I'm not hostile against 
>> other operating systems, but I simply am not interested enough in 
>> them to spend my time improving them.
> 
> In fact one of the problems i see with Qemu is that Qemu had to make 
> many compromises to support Windows and other weird platforms that 
> i'm (and i'd claim most other Linux kernel developers) are personally 
> not interested in.

It's what makes it so powerful. Adding a new architecture for KVM for example is as easy as only implementing the CPU. All device emulation is already there. If you want something Linux only, lguest would've been enough, no?

The only real problem I see with Qemu is that it's been born in a time of uniprocessor systems. Making it fully threaded as an after-thought is insanely hard.

> So here's a 14 KLOC tools/kvm/ that does everything that i need from 
> virtualization (easy testing of a bzImage before rebooting the host 
> system into it), is clean, readable and hackable and is 1.5% of the 
> nearly 1 MLOC Qemu code base.

Sure, we'll talk again when you can run Android for ARM on kvm-tool.

> The whole tools/kvm/ code base is (much) smaller than Qemu's IA64 
> support code for example. The size difference is startling. 

That's the host code compiler. Qemu doesn't have IA64 guest support.

> tools/kvm/ does less and in my experience does it better - is that 
> such a surprising thing?

I already stated in a few mails before and also in the last discussion that I'm in general in favor of having multiple user space targets for KVM. In fact, I wrote 2 backends (both for PPC) myself. Though adding those 2 backends to their respective projects probably provided a lot more value-add (features that qemu didn't already have) than kvm-tool does atm. Kvm-tool really just smells a lot like NIH. Which is fine - that's why we have KDE and Gnome, right? ;)

> So it was a no brainer for me to pull it into -tip.

The thing I don't agree with is that it should live in the kernel tree.


Alex

