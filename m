Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab1GYJDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 05:03:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab1GYJDo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 05:03:44 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20110725085426.GA28787@elte.hu>
Date: Mon, 25 Jul 2011 11:03:32 +0200
Cc: Pekka Enberg <penberg@kernel.org>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, levinsasha928@gmail.com,
        asias.hejun@gmail.com, prasadjoshi124@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <C80CB058-38B3-4EA4-996F-4585F521415C@suse.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger> <4E2CA6DE.4040900@web.de> <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com> <20110725075305.GA32294@elte.hu> <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de> <20110725085426.GA28787@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25.07.2011, at 10:54, Ingo Molnar wrote:

> 
> * Alexander Graf <agraf@suse.de> wrote:
> 
>> On 25.07.2011, at 09:53, Ingo Molnar wrote:
>> 
>>> 
>>> * Pekka Enberg <penberg@kernel.org> wrote:
>>> 
>>>> On Mon, Jul 25, 2011 at 2:12 AM, Jan Kiszka <jan.kiszka@web.de> wrote:
>>>>> 
>>>>> That said, I definitely appreciate the bug fixes as well as 
>>>>> code and documentation improvements for KVM that originate from 
>>>>> this effort! I'm just not convinced that writing a new userland 
>>>>> and merging it into the kernel is the most efficient way to 
>>>>> achieve that.
>>>> 
>>>> Just to make this crystal clear for everyone: if it weren't for 
>>>> tools/kvm, I wouldn't be hacking on KVM at all. I've looked at 
>>>> Qemu in the past (and a lot recently!) and I simply don't see 
>>>> myself contributing to it, sorry. So 'most efficient' or not, I 
>>>> think tools/kvm is a net win for Linux and KVM in general.
>>> 
>>> Same here - in fact i first asked Qemu to be put into tools/qemu/ 
>>> so that it all becomes more hackable and more usable - that 
>>> suggestion was rebuked very strongly.
>> 
>> So instead of thinking a bit and trying to realize that there might 
>> be a reason people don't want all their user space in the kernel 
>> tree you go ahead and start your own crusade of creating a new user 
>> space. Great. That's how I always hoped Linux would be :(.
> 
> Not "all their user space" but the ones that are tightly integrated 
> with the kernel to begin with. How hard is that concept to 
> understand?

It's very hard to understand. It's similar to religion - I could easily apply your point to every reasonably low-level user space project out there. X for example. X needs to interact with KMS and DRI and whatdoiknow. So it'd be a perfect fit to pull into tools/, no?

> Virtualization is very tightly bound to the kernel, like it or not. 

I don't see why. The whole point of virtualization is to model simple, with KVM preferably even very-close-to-real-hardware interfaces that allow you to keep things separate.

> So is profiling, power management and a few other things.

I'm also failing to see the reasoning here TBH.

> And when you do 'ls tools/' you'll see exactly those topics 
> populated:
> 
> earth5:~/tip> ls tools/
> firewire  kvm  perf  power  slub  testing  usb  virtio
> 
> [ In fact tools/virtio/ was merged upstream yesterday and putting 
>  that code there was a good call IMO. ]
> 
> So just as there are good reasons to keep some user-space projects 
> out of the kernel tree (while i'd love to see a usable mail client 
> for Linux i dont think it belongs into tools/) there are similarly 
> good reasons to keep some of them in the kernel tree.
> 
> tools/kvm/ is an excellent example for that, just look at the code - 
> it shares code with the kernel, uses the kernel coding style, is in 
> significant part developed by kernel developers and it is being used 
> by kernel developers.

Then make a separate tree, add the kernel as git submodule and simply pull in your library/header dependencies from there. Shouldn't be too hard, no?

> I wish there was a hackable tools/qemu/ base but there isnt and won't 
> be any. The thing i *can* do is to help create a hackable 
> virtualization tool.

What's the problem with a code base that's hackable, but not in tools/?

> 
>>> So i wanted to have a lightweight tool that allows me to test KVM 
>>> and tools/kvm/ does that very nicely: i type './kvm run' and i 
>>> can test a native bzImage (which has some virtualization options 
>>> enabled as well) on the _host_ distro i am running, booting to a 
>>> text shell prompt.
>> 
>> I do that all the time.
>> 
>>  $ qemu-kvm -nographic -kernel arch/x86/boot/bzImage -append console=ttyS0
>> 
>> does the exact same thing. If that's too much typing for you, make 
>> it a bash alias.
> 
> This only boots the bzImage itself and panics when it would like to 
> hit user-space.

Well, sure.

> 
>>> I can do that without downloading any (inevitably outdated) 
>>> virtualization images or maintaining my own ones. Maintaining 
>>> host userspace is more than enough for me.
>> 
>> Who would need images? I usually only run -kernel and -initrd 
>> directly to test out things. Or if I really want to boot into a 
>> real system I do -snapshot /dev/sda.
> 
> that too panics here, while with tools/kvm/ i get to a prompt:
> 
> [root@aldebaran ~]# uptime
>  08:42:13 up 0 min,  0 users,  load average: 0.00, 0.00, 0.00
> 
> But i agree with you that obviously Qemu (or my usage of parameters, 
> whichever is the problem) could be fixed to do this correctly.

Well, you need to make sure to pass the right partition into -append. No idea what ./kvm run does, but it's certainly something easily scriptable with any other virtualization user land.

> 
>>> So, since we already have the lguest tool in the kernel tree, why 
>>> cannot we have the much more capable tools/kvm/ in the tree?
>> 
>> Lguest is in Documentation/ for a reason. It's not meant as a user 
>> space tool that you take as-is and use. It's meant for documenting 
>> how lguest works in general. I admit though, that that's also the 
>> reason people don't use it :).
> 
> There's an obvious contrast with the request to merge tools/kvm/ to 
> lguest (not brought up by me) and your description of lguest only 
> being for documentation purposes, not to be used really, etc.
> 
> I wanted to highlight this contrast, so if you thought we disagree 
> much about lguest i don't think we do.

I don't think we disagree about lguest :).

> 
>>> So while it is the Qemu folks' right to oppose tools/qemu/, i 
>>> don't see why they are opposing tools/kvm/ ...
>> 
>> In your logic, you would put all of the GNU utils into tools/. This 
>> is just plain insane. There's a reason we have the split between 
>> kernel and user space. What does putting them into the same tree 
>> bring you? Fame? Glorious stats on kernel commits? Seriously, it's 
>> a separate project. It's not the kernel.
> 
> Where did i claim that *all* user-space projects need to move into 
> the kernel tree? It's all case by case. Before you argue against a 
> position and ridicule it you need to understand it.

I'm slightly exaggerating, but that's the trend I'm seeing.


Alex

