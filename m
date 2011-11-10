Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506Ab1KJBmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 20:42:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756899Ab1KJBl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 20:41:59 -0500
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git repository, tools/perf/ and tools/kvm/
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20111109082321.GA11473@elte.hu>
Date: Thu, 10 Nov 2011 02:41:53 +0100
Cc: "Ted Ts'o" <tytso@mit.edu>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <B14DBEB6-46F3-4A30-9FFF-F085A03F32F4@suse.de>
References: <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy> <CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com> <20111107203255.GF24234@thunk.org> <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com> <4EB85969.2010108@codemonkey.ws> <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu> <20111108093225.GB32533@elte.hu> <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu> <20111108125509.GB1022@elte.hu> <20111108163331.GJ24234@thunk.org> <20111109082321.GA11473@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09.11.2011, at 09:23, Ingo Molnar wrote:

> 
> * Ted Ts'o <tytso@mit.edu> wrote:
> 
>> On Tue, Nov 08, 2011 at 01:55:09PM +0100, Ingo Molnar wrote:
>> 
>>> I guess you can do well with a split project as well - my main 
>>> claim is that good compatibility comes *naturally* with 
>>> integration.
>> 
>> Here I have to disagree; my main worry is that integration makes it 
>> *naturally* easy for people to skip the hard work needed to keep a 
>> stable kernel/userspace interface.
> 
> There's two observations i have:
> 

[...]

> I don't think your argument makes much sense: how come Linux, a 15 
> MLOC monster project running for 20 years has not been destroyed by 
> the "lack of the safety valve" problem? Why would adding the at most 
> 1 MLOC deeply kernel related Linux tool and library space to the 
> kernel repo affect the dynamics negatively? We added more code to the 
> kernel last year alone.
> 
> Fact is, competition thrives within the Linux kernel as well. Why is 
> a coherent, unified, focused project management an impediment to a 
> good technological result? Especially when it comes to desktop 
> computers / tablets / smartphones, where having a unified project is 
> a *must*, so extreme are the requirements of users to get a coherent 
> experience.
> 
> Think about this plain fact: there's not a single successful 
> smartphone OS on the market that does not have unified project 
> management. Yes, correlation is not causation and such, but still, 
> think about it for a moment.

I see your arguments and I think others do too. Look at the BSD or Solaris guys. Heck, even Windows and Mac OS have a lot tighter user-space and kernel bindings than we do.

However I don't see any real reason for us who already have the strong syscall ABI boundary as border defined to change that anytime soon. So far it's worked out pretty well IMHO.

But yes, if you were to push things from the bottom up, it would even make sense. If you were to push glibc into the kernel it would make sense. I maybe still wouldn't agree with it, but it'd at least be logical, because that's the next layer from the kernel's point of view.

If you were to push busybox into the kernel, it would also make sense, so that you can have a fully self-contained system that doesn't need external dependencies built inside a single tree. Again, I wouldn't agree on it because I like user space to be multi platform, but I could see the point. The same goes for udev and systemd.

For kvm tool however, I don't. It's very very high up the stack. In fact, I can't imagine too many applications being too much higher up the stack than a VM monitor. It needs to talk to the user (gtk?). It needs to talk to the network (which might be implemented using vde). It needs to talk to storage (which could be hidden behind user space libraries). It basically is a consumer of all the interfaces we provide 50 layers above the kernel.

So I find the comparison of pulling GNOME3 and KVM Tool into the kernel fair. Both depend on about the same amount of user space. And even though KVM Tool might not depend on all that much today, I'm sure you guys don't want to limit yourselves in scope just because you're "in the kernel tree".

Outside of the kernel tree, you can do your own decisions. If someone thinks it's a great idea to write device emulation in python (I would love that!), he could go in and implement it without having to worry about Linus possibly rejecting it because it's out of scope for a "Linux kernel testing tool". If you want to create the greatest GUI for virtualization the world has ever seen, you can just do it! Nothing holds you back.

You already have a very thriving development community. There are active contributers all over the place in KVM Tool. People already are interested in it. Why do you want to be in the kernel tree so badly? I honestly think it would rather hurt the project rather than help it.

So in all honesty, I wish for a KVM Tool outside of the kernel tree so it can thrive and evolve into something great - without artificial borders. And I'm sure most of the KVM Tool developers wish for the thriving part as well - which I believe can not happen inside the kernel tree.


Alex

