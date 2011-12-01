Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1LADSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:18:40 -0500
Received: from ozlabs.org ([203.10.76.45]:60626 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab1LADRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:17:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
In-Reply-To: <20111130231306.GD30031@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com> <20111129131110.GC19157@redhat.com> <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com> <20111129151958.GA31789@redhat.com> <CAK=WgbZ5aBFNro3XC0cN+Ao4ZWrBHwwd3d__CSHA=n56gKmKXw@mail.gmail.com> <20111130145004.GD21413@redhat.com> <CAK=WgbY59n9N_-2_TZ9wNBNcTMV1DCrz65e-Ae=xamcg6A0dOA@mail.gmail.com> <20111130231306.GD30031@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 01 Dec 2011 12:58:59 +1030
Message-ID: <87zkfdrpn8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011 01:13:07 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> For x86, stores into memory are ordered. So I think that yes, smp_XXX
> can be selected at compile time.
> 
> So let's forget the virtio strangeness for a minute,

Hmm, we got away with light barriers because we knew we were not
*really* talking to a device.  But now with virtio-mmio, turns out we
are :)

I'm really tempted to revert d57ed95 for 3.2, and we can revisit this
optimization later if it proves worthwhile.

Thoughts?
Rusty. 
