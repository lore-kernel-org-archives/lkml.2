Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab1LBBLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:11:03 -0500
Received: from ozlabs.org ([203.10.76.45]:35300 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab1LBBK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:10:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
In-Reply-To: <20111201081236.GB5479@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com> <20111129131110.GC19157@redhat.com> <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com> <20111129151958.GA31789@redhat.com> <CAK=WgbZ5aBFNro3XC0cN+Ao4ZWrBHwwd3d__CSHA=n56gKmKXw@mail.gmail.com> <20111130145004.GD21413@redhat.com> <CAK=WgbY59n9N_-2_TZ9wNBNcTMV1DCrz65e-Ae=xamcg6A0dOA@mail.gmail.com> <20111130231306.GD30031@redhat.com> <87zkfdrpn8.fsf@rustcorp.com.au> <20111201081236.GB5479@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 02 Dec 2011 10:56:33 +1030
Message-ID: <8762hzsts6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011 10:12:37 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Dec 01, 2011 at 12:58:59PM +1030, Rusty Russell wrote:
> > On Thu, 1 Dec 2011 01:13:07 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > For x86, stores into memory are ordered. So I think that yes, smp_XXX
> > > can be selected at compile time.
> > > 
> > > So let's forget the virtio strangeness for a minute,
> > 
> > Hmm, we got away with light barriers because we knew we were not
> > *really* talking to a device.  But now with virtio-mmio, turns out we
> > are :)
> 
> You think virtio-mmio this issue too?  It's reported on remoteproc...

I think any non-virtual, non-PCI device has to worry about it.  Perhaps
all virtio-mmio are virtual (at this point).

I'm tempted to say we want permission from the device to do relaxed
barriers (so I don't have to worry about it!)

> > I'm really tempted to revert d57ed95 for 3.2, and we can revisit this
> > optimization later if it proves worthwhile.
> 
> Generally it does seem the best we can do for 3.2.
> 
> Given it's rc3, I'd be a bit wary of introducing regressions - I'll try
> to find some real setups (as in - not my laptop) to run some benchmarks
> on, to verify there's no major problem.
> I hope I can report on this in about a week from now - want to hold onto this meanwhile?

Yep, no huge hurry.  Thanks!

Cheers,
Rusty.
