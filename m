Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab0CRKkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 06:40:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab0CRKkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 06:40:47 -0400
Message-ID: <4BA2030B.3090007@redhat.com>
Date: Thu, 18 Mar 2010 11:40:11 +0100
From: Jes Sorensen <Jes.Sorensen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316112500.GA5337@elte.hu> <4B9F77E7.2060101@redhat.com> <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E7E2.3010803@redhat.com> <20100318095418.GD2157@elte.hu>
In-Reply-To: <20100318095418.GD2157@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/10 10:54, Ingo Molnar wrote:
> * Jes Sorensen<Jes.Sorensen@redhat.com>  wrote:
[...]
>>
>> At my previous employer we ended up dropping all Xen efforts exactly because
>> it was like maintaining two separate operating system kernels. The key to
>> KVM is that once you have Linux, you practically have KVM as well.
>
> Yes. Please realize that what is behind it is a strikingly simple argument:
>
>   "Once you have a single project to develop and maintain all is much better."

Thats a very glorified statement but it's not reality, sorry. You can do
that with something like perf because it's so small and development of
perf is limited to a very small group of developers.

>> [...] However, there is far more to it than just a couple of ioctls, for
>> example the stack of reverse device-drivers is a pretty significant code
>> base, rewriting that and maintaining it is not a trivial task. It is
>> certainly my belief that the benefit we get from sharing that with QEMU by
>> far outweighs the cost of forking it and keeping our own fork in the kernel
>> tree. In fact it would result in exactly the same problems I mentioned above
>> wrt Xen.
>
> I do not suggest forking Qemu at all, i suggest using the most natural
> development model for the KVM+Qemu shared project: a single repository.

If you are not suggesting to fork QEMU, what are you suggesting then?
You don't seriously expect that the KVM community will be able to
mandate that the QEMU community switch to the Linux kernel repository?
That would be like telling the openssl developers that they should merge
with glibc and start working out of the glibc tree.

What you are suggesting is *only* going to happen if we fork QEMU, there
is zero chance to move the main QEMU repository into the Linux kernel
tree. And trust me, you don't want to have Linus having to deal with
handling patches for tcg or embedded board emulation.

>> With this you have just thrown away all the benefits of having the QEMU
>> repository shared with other developers who will actively fix bugs in
>> components we do care about for KVM.
>
> Not if it's a unified project.

You still haven't explained how you expect create a unified KVM+QEMU
project, without forking from the existing QEMU.

>>>   - encourage kernel-space and user-space KVM developers to work on both
>>>     user-space and kernel-space bits as a single unit. It's one project and
>>>     a single experience to the user.
>>
>> This is already happening and a total non issue.
>
> My experience as an external observer of the end result contradicts this.

What I have seen you complain about here is the lack of a good end user
GUI for KVM. However that is a different thing. So far no vendor has put
significant effort into it, but that is nothing new in Linux. We have a
great kernel, but our user applications are still lacking. We have 217
CD players for GNOME, but we have no usable calendering application.

A good GUI for virtualization is a big task, and whoever designs it will
base their design upon their preferences for whats important. A lot of
spare time developers would clearly care most about a gui installation
and fancy icons to click on, whereas server users would be much more
interested in automation and remote access to the systems. For a good
example of an incomplete solution, try installing Fedora over a serial
line, you cannot do half the things without launching VNC :( Getting a
comprehensive solution for this that would satisfy the bulk of the users
would be a huge chunk of code in the kernel tree. Imagine the screaming
that would result in? How often have we not had the moaning from x86
users who wanted to rip out all the non x86 code to reduce the size of
the tarball?

> Seemingly trivial usability changes to the KVM+Qemu combo are not being done
> often because they involve cross-discipline changes.

Which trivial usability changes?

>>>   - [ and probably libvirt should go there too ]
>>
>> Now that would be interesting, next we'll have to include things like libxml
>> in the kernel git tree as well, to make sure libvirt doesn't get out of sync
>> with the version supplied by your distribution vendor.
>
> The way we have gone about this in tools/perf/ is similar to the route picked
> by Git: we only use very lowlevel libraries available everywhere, and we
> provide optional wrappers to the rest.

Did you ever look at what libvirt actually does and what it offers? Or
how about the various libraries used by QEMU to offer things like VNC
support or X support?

Again this works fine for something like perf where the primary
display is text mode.

>> So far your argument would justify pulling all of gdb into the kernel git
>> tree as well, to support the kgdb efforts, or gcc so we can get rid of the
>> gcc version quirks in the kernel header files, e2fsprogs and equivalent for
>> _all_ file systems included in the kernel so we can make sure our fs tools
>> never get out of sync with whats supported in the kernel......
>
> gdb and gcc is clearly extrinsic to the kernel so why would we move them
> there?

gdb should go with kgdb which goes with the kernel to keep it in sync.
If you want to be consistent in your argument, you have to go all the
way.

> I was talking about tools that are closely related to the kernel - where much
> of the development and actual use is in combination with the Linux kernel.

Well the file system tools would obviously have to go into the kernel
then so appropriate binaries can be distributed to match the kernel.

> 90%+ of the Qemu usecases are combined with Linux. (Yes, i know that you can
> run Qemu without KVM, and no, i dont think it matters in the grand scheme of
> things and most investment into Qemu comes from the KVM angle these days. In
> particular it for sure does not justify handicapping future KVM evolution so
> drastically.)

90+%? You got to be kidding? You clearly have no idea just how much it's
used for running embedded emulators on non Linux. You should have seen
the noise it made when I added C99 initializers to certain structs,
because it broke builds using very old GCC versions on BeOS. Linux only,
not a chance. Try subscribing to qemu-devel and you'll see a list that
is only overtaken by few lists like lkml in terms of daily traffic.

>> Oh and you completely forgot SeaBIOS. KVM+QEMU rely on SeaBIOS too, so from
>> what you're saying we should pull that into the kernel git repository as
>> well. Never mind the fact that we share SeaBIOS with the coreboot project
>> which is very actively adding features to it that benefit us as well.....
>
> SeaBIOS is in essence a firmware, so it could either be loaded as such.
>
> Just look at the qemu source code - the BIOSes are .bin images in
> qemu/pc-bios/ imported externally in essence.

Ehm no, QEMU now pulls in SeaBIOS to build it. And there are a lot of
changes that require modification in SeaBIOS to match changes to QEMU.

> qemu-kvm branch is not similar to my proposal at all: it made KVM _more_
> fragmented, not more unified. I.e. it was a move in the exact opposite
> direction and i'd expect such a move to fail.
>
> In fact the failure of qemu-kvm supports my point rather explicitly: it
> demonstrates that extra packages and split development are actively harmful.

Ehm it showed what happens when you fork QEMU to modify it primarily for
your own project, ie. KVM. You are suggesting we fork QEMU for the
benefit of KVM, and it will be exactly the same thing that happens.

I know you state that you are not suggesting we fork it, but as I showed
above, pulling QEMU into the kernel tree, can only happen as a fork.
There is no point pretending otherwise.

> I speak about this as a person who has done successful unifications of split
> codebases and in my judgement this move would be significantly beneficial to
> KVM.
>
> You cannot really validly reject this proposal with "It wont work" as it
> clearly has worked in other, comparable cases. You could only reject this with
> "I have tried it and it didnt work".
>
> Think about it: a clean and hackable user-space component in tools/kvm/. It's
> very tempting :-)

I say this based on my hacking experience, my experience with the
kernel, the QEMU base, SeaBIOS and merging projects. Yes it can be done,
but the cost is much higher than the gain.

Cheers,
Jes
