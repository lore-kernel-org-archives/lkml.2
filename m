Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab1K3Wnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 17:43:31 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44333 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab1K3Wn3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 17:43:29 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.19.40]
In-Reply-To: <20111130145004.GD21413@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
 <20111129131110.GC19157@redhat.com> <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
 <20111129151958.GA31789@redhat.com> <CAK=WgbZ5aBFNro3XC0cN+Ao4ZWrBHwwd3d__CSHA=n56gKmKXw@mail.gmail.com>
 <20111130145004.GD21413@redhat.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 1 Dec 2011 00:43:08 +0200
Message-ID: <CAK=WgbY59n9N_-2_TZ9wNBNcTMV1DCrz65e-Ae=xamcg6A0dOA@mail.gmail.com>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 4:50 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> make headers_install
> make -C tools/virtio/
> (you'll need an empty stub for tools/virtio/linux/module.h,
>  I just sent a patch to add that)
> sudo insmod tools/virtio/vhost_test/vhost_test.ko
> ./tools/virtio/virtio_test

Ok, I gave this a spin.

I've tried to see if reverting d57ed95 has any measurable effect on
the execution time of virtio_test's run_test(), but I couldn't see any
(several attempts with and without d57ed95 yielded very similar range
of execution times).

YMMV though, especially with real workloads.

> Real virtualization/x86 can keep using current smp_XX barriers, right?

Yes, sure. ARM virtualization can too, since smp_XX barriers are
enough for that scenario.

> We can have some config for your kind of setup.

Please note that it can't be a compile-time decision though (unless
we're willing to effectively revert d57ed95 when this config kicks
in): it's not unlikely that one would want to have both use cases
running on the same time.

Thanks,
Ohad.
