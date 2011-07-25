Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab1GYIOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:14:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab1GYIOQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:14:16 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20110725075305.GA32294@elte.hu>
Date: Mon, 25 Jul 2011 10:14:13 +0200
Cc: Pekka Enberg <penberg@kernel.org>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger> <4E2CA6DE.4040900@web.de> <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com> <20110725075305.GA32294@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25.07.2011, at 09:53, Ingo Molnar wrote:

> 
> * Pekka Enberg <penberg@kernel.org> wrote:
> 
>> On Mon, Jul 25, 2011 at 2:12 AM, Jan Kiszka <jan.kiszka@web.de> wrote:
>>> That said, I definitely appreciate the bug fixes as well as code and
>>> documentation improvements for KVM that originate from this effort! I'm
>>> just not convinced that writing a new userland and merging it into the
>>> kernel is the most efficient way to achieve that.
>> 
>> Just to make this crystal clear for everyone: if it weren't for 
>> tools/kvm, I wouldn't be hacking on KVM at all. I've looked at Qemu 
>> in the past (and a lot recently!) and I simply don't see myself 
>> contributing to it, sorry. So 'most efficient' or not, I think 
>> tools/kvm is a net win for Linux and KVM in general.
> 
> Same here - in fact i first asked Qemu to be put into tools/qemu/ so 
> that it all becomes more hackable and more usable - that suggestion 
> was rebuked very strongly.

So instead of thinking a bit and trying to realize that there might be a reason people don't want all their user space in the kernel tree you go ahead and start your own crusade of creating a new user space. Great. That's how I always hoped Linux would be :(.

> So i wanted to have a lightweight tool that allows me to test KVM and 
> tools/kvm/ does that very nicely: i type './kvm run' and i can test a 
> native bzImage (which has some virtualization options enabled as 
> well) on the _host_ distro i am running, booting to a text shell 
> prompt.

I do that all the time.

  $ qemu-kvm -nographic -kernel arch/x86/boot/bzImage -append console=ttyS0

does the exact same thing. If that's too much typing for you, make it a bash alias.

> I can do that without downloading any (inevitably outdated) 
> virtualization images or maintaining my own ones. Maintaining host 
> userspace is more than enough for me.

Who would need images? I usually only run -kernel and -initrd directly to test out things. Or if I really want to boot into a real system I do -snapshot /dev/sda.

> So, since we already have the lguest tool in the kernel tree, why 
> cannot we have the much more capable tools/kvm/ in the tree?

Lguest is in Documentation/ for a reason. It's not meant as a user space tool that you take as-is and use. It's meant for documenting how lguest works in general. I admit though, that that's also the reason people don't use it :).

> So while it is the Qemu folks' right to oppose tools/qemu/, i don't 
> see why they are opposing tools/kvm/ ...

In your logic, you would put all of the GNU utils into tools/. This is just plain insane. There's a reason we have the split between kernel and user space. What does putting them into the same tree bring you? Fame? Glorious stats on kernel commits? Seriously, it's a separate project. It's not the kernel.

> Wrt. integration with lguest - this is a new argument that was not 
> brought up before (i wish people would not come up with new 
> requirements on the day of the pull request) - i don't see how it's 
> relevant really: lguest was designed for legacy CPUs and tools/kvm/ 
> is precisely about being simple and not doing legacy stuff.
> 
> If then Qemu should be the project that integrates lguest. Is anyone 
> on the Qemu side looking at lguest integration?

I don't think lguest integration makes sense for anyone or anything. Lguest is a toy, so let it be the toy it wants to be.


Alex

