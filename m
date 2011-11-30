Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab1K3QFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 11:05:19 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63394 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab1K3QFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 11:05:17 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.19.40]
In-Reply-To: <20111130145958.GE21413@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
 <20111129131110.GC19157@redhat.com> <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
 <20111129151607.GE30966@redhat.com> <CAK=WgbZK+k4uuyMPHUfr_PMyrR5ceRTvuDRpmhXfgwpSUOPw0g@mail.gmail.com>
 <20111130145958.GE21413@redhat.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 30 Nov 2011 18:04:56 +0200
Message-ID: <CAK=WgbYyFdLftE_kp2_JOThVhn-FzGsDqVqKn0Jwm2teQyZBNA@mail.gmail.com>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 4:59 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> I see. And this happens because the ARM processor reorders
> memory writes

Yes.

> And in an SMP configuration, writes are somehow not reordered?

They are, but then the smp memory barriers are enough to control these
effects. It's not enough to control reordering as seen by a device
(which is what our AMP processors are) though.

(btw, the difference between an SMP processor and a device here lies
in how the memory is mapped: normal memory vs. device memory
attributes. it's an ARM thingy).

> Just checking that this is not a bug in the smp_wmb implementation
> for the specific platform.

No, it's not.

ARM's smp memory barriers use ARM's DMB instruction, which is enough
to control SMP effects, whereas ARM's mandatory memory barriers use
ARM's DSB instruction, which is required to ensure the ordering
between Device and Normal memory accesses.

Thanks,
Ohad.
