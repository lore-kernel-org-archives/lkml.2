Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab2DQFYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 01:24:36 -0400
Received: from 1wt.eu ([62.212.114.60]:65240 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab2DQFYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 01:24:35 -0400
Date: Tue, 17 Apr 2012 07:24:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [ath9k-devel] [ 00/78] 3.3.2-stable review
Message-ID: <20120417052401.GB5522@1wt.eu>
References: <20120413105746.10ffb120@stein> <CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com> <20120413190819.9469.qmail@stuge.se> <CAMP44s02v_OhviaF12Y8LWBJygyVLZk00d3P69GVvKAeJwjiuw@mail.gmail.com> <20120416162710.GA24100@kroah.com> <CAMP44s1o9kBp8672oBnvna+qH4WpqSqGUsyNpc_C74cfNYcX_g@mail.gmail.com> <20120416205856.GA22298@kroah.com> <CAMP44s2OdH+1RG2O6+QXkik8Ww_ZSHN=yzEKwD1KvRAcceNSRA@mail.gmail.com> <20120416212718.GA22824@kroah.com> <CAMP44s2bg8AC+jMXRv-GoRaag2qDgttHoVWmKOxH7zTg4-qtLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP44s2bg8AC+jMXRv-GoRaag2qDgttHoVWmKOxH7zTg4-qtLQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 12:44:25AM +0300, Felipe Contreras wrote:
> >> Perhaps the current process will be continue to be OK, but I do
> >> believe a tagged v3.3.1-rc1 would have catched the ath9k issue.
> >
> > How exactly would that have helped here?
> 
> More people would have given it a try. Not that many people read the
> mailing list, and the ones that do certainly might want to avoid
> applying a big series of patches; even if their mail client makes it
> easy (mine (Gmail) doesn't). A tag, and an announcement to give a try
> would make it *much* easier.

That's totally unrelated. A tag means that these changes would have been
committed (with history etc...). This would not have changed anything of
the running/broken code. It would have failed similarly without any way
for you to revert. The rc1 was announced and was available on kernel.org.
A tag would not have changed anything here, except by making the release
process much more complex by basically having to revert every unsuitable
patch instead of dropping it. It would mean that rc1 would in fact have
been 3.3.1 and that 3.3.1 would have been 3.3.2. You just shift the release
by one number and don't bring any value here.

> >> I used to compile my own kernels and use your stable tree, but this a
> >> new laptop and I was using Arch Linux which automatically updated to
> >> v3.3.1, and with no network I had no way to revert to v3.2.x.
> >> Fortunately I had the kernel sources available, but I wonder how many
> >> people were completely stuck.
> >
> > Arch wouldn't have included a -rc in their kernel (unless they are
> > crazy), so this would not have helped your situation at all.
> 
> There's *a lot* of people that got affected by the 3.3.1 release; we
> don't need to break a lot of boxes to figure out there's an issue,
> only a few would suffice, even one.

I'm sorry, but I don't buy this. There are *always* regressions caused by
kernel updates, and even the beginners I know are used to keep a working
kernel on their systems precisely because they know they can be left with
something which does not boot anymore. So if you upgrade your *only* kernel
without keeping a safe one, it's not a mistake, it's a fault, your fault. A
beginner wouldn't have done this. You wouldn't have recovered from a hanging
boot, a panic or a SATA timeout either. Drivers issues are the worst ones
because nobody can exhaustively test them all, not even your distro vendor.
The solution is always to keep a working kernel as an alternate boot.

> >> If some other 3.x.1 release get broken this way, I would seriously
> >> consider tagging v3.x.1-rc1 as well. It works for Linus' tree.
> >
> > "this way" was for a very tiny subset of hardware, so odds are, if this
> > happens again, it wouldn't be caught this way either.  That subset just
> > happened to show up in your machine, but, for example, not in the wide
> > range of hardware I test with here, nor the machines that others test
> > with.
> 
> It was certainly not just me. I have seen a lot of people mentioning
> "their wifi is broken", a lot of them using Arch Linux,
> coincidentally.

Maybe because these are people you know and you taught to blindly update
without keep a safe boot option ?

Now it becomes a lot clearer that you want a user fault to be covered by
a development process. That will never ever work because the only way it
will solve your behavioral issue is to release 100% safe and 100% compatible
kernels each time, which by definition is not possible if anything changes.

Willy

