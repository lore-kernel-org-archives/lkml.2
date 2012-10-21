Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2JUSJj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 14:09:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48602 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab2JUSJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 14:09:38 -0400
Date: Sun, 21 Oct 2012 20:09:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Borislav Petkov <bp@alien8.de>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Dave Airlie <airlied@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
Message-ID: <20121021180933.GA4465@gmail.com>
References: <20121020181425.GA11191@liondog.tnic>
 <CAPM=9twcHxUGgYUc27DV1AcYZbzKSbA1Bru8vK1kcWvcG0Jpkw@mail.gmail.com>
 <20121021110329.GA7024@infradead.org>
 <20121021125933.GC19535@gmail.com>
 <CAFLxGvzLOa-BibZ39_yMEC70AseEPbtjcNGk6jLwaAVsU2ujwA@mail.gmail.com>
 <20121021150305.GA26108@gmail.com>
 <20121021171543.GC20642@liondog.tnic>
 <20121021174041.GA240@x4>
 <20121021175108.GA3820@gmail.com>
 <20121021175422.GB240@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121021175422.GB240@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> On 2012.10.21 at 19:51 +0200, Ingo Molnar wrote:
> > 
> > * Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> > 
> > > On 2012.10.21 at 19:15 +0200, Borislav Petkov wrote:
> > > > On Sun, Oct 21, 2012 at 05:03:05PM +0200, Ingo Molnar wrote:
> > > > > The best way to compare them would be a script that gives exactly the
> > > > > same test environment that 'vm run' / 'vm sandbox' does out of box,
> > > > > but using qemu.
> > > > >
> > > > > If such a script is available then that would certainly be a useful
> > > > > testing option to kernel developers.
> > > > 
> > > > Right,
> > > > 
> > > > I gotta say, I've mucked around with qemu/kvm net options as a novice
> > > > user and haven't always been successfu. If you get host networking
> > > > straight away in lkvm then that's another clear point for tools/kvm.
> > > > 
> > > > Same holds true for copying data back and forth between host and guest.
> > > 
> > > I'm agnostic about lkvm, but the following command does all the above:
> > > 
> > > qemu-system-x86_64 -enable-kvm -net nic,vlan=0,model=virtio 
> > > -net user -fsdev 
> > > local,security_model=passthrough,id=root,path=/ -device 
> > > virtio-9p-pci,id=root,fsdev=root,mount_tag=/dev/root -m 512 
> > > -smp 2 -kernel /usr/src/linux/arch/x86/boot/bzImage -nographic 
> > > -append "init=/bin/zsh root=/dev/root console=ttyS0 
> > > kgdboc=ttyS0 rootflags=rw,trans=virtio rootfstype=9p ip=dhcp"
> > > 
> > > If you want your host root-fs to be mounted rw (to copy data
> > > back and forth) you need to run to above as root and add "rw"
> > > to the kernel options.
> > 
> > Why does it have to run as root? I run 'vm' unprivileged (other 
> > than /dev/kvm access).
> 
> From the qemu man page:
> 
>  security_model=security_model
> 
>   Specifies the security model to be used for this export 
> path.  Supported security models are "passthrough", "mapped- 
> xattr", "mapped-file" and "none". In "passthrough" security 
> model, files are stored using the same credentials as they are 
> created on the guest. This requires QEMU to run as root.

So I guess running it with 'none' can be used unprivileged?

Thanks,

	Ingo
