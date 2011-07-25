Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab1GYKih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:38:37 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46063
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093Ab1GYKia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:38:30 -0400
Date: Mon, 25 Jul 2011 06:38:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Graf <agraf@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Jan Kiszka <jan.kiszka@web.de>, torvalds@linux-foundation.org,
        avi@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gorcunov@gmail.com,
        levinsasha928@gmail.com, asias.hejun@gmail.com,
        prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Message-ID: <20110725103817.GA21683@infradead.org>
References: <alpine.DEB.2.00.1107242335580.18045@tiger>
 <4E2CA6DE.4040900@web.de>
 <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com>
 <20110725075305.GA32294@elte.hu>
 <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 10:14:13AM +0200, Alexander Graf wrote:
> So instead of thinking a bit and trying to realize that there might be a reason people don't want all their user space in the kernel tree you go ahead and start your own crusade of creating a new user space. Great. That's how I always hoped Linux would be :(.

It's not Linux in general yet, it's mostly a crusade of a few with a
political agenda.

> > So i wanted to have a lightweight tool that allows me to test KVM and 
> > tools/kvm/ does that very nicely: i type './kvm run' and i can test a 
> > native bzImage (which has some virtualization options enabled as 
> > well) on the _host_ distro i am running, booting to a text shell 
> > prompt.
> 
> I do that all the time.
> 
>   $ qemu-kvm -nographic -kernel arch/x86/boot/bzImage -append console=ttyS0

Same here.  I can't be bothered with all the stuid distro booting crap.

> > I can do that without downloading any (inevitably outdated) 
> > virtualization images or maintaining my own ones. Maintaining host 
> > userspace is more than enough for me.
> 
> Who would need images? I usually only run -kernel and -initrd directly to test out things. Or if I really want to boot into a real system I do -snapshot /dev/sda.

Indeed.

> 
> > So, since we already have the lguest tool in the kernel tree, why 
> > cannot we have the much more capable tools/kvm/ in the tree?
> 
> Lguest is in Documentation/ for a reason. It's not meant as a user space tool that you take as-is and use. It's meant for documenting how lguest works in general. I admit though, that that's also the reason people don't use it :).

I'd also say it's rather misplaced there, and at least in the storage
area that I know most it didn't help it from totally misunderstanding
kernel concepts and taking them into protocols (e.g. virtio barrier
support).  That for me is a reason why you don't want to couple thing
too tightly, at least you'll have to document and/or explain the
protocol to someone. 
tight

And another argument, calling toyvisor2 "kvm" is a really bad idea.  The
kvm binary has been used for the kvm-patched qemu binary for quite a
while in various distros, so re-using that name will cause utter
confusion.

I'm happy that you guys do another independent userspace for kvm, but
please:

  a) give it a useful name
  b) just develop it where it belongs, your own little git repository
     somewhere
