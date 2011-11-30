Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab1K3QYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 11:24:40 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33477 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1K3QYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 11:24:38 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.19.40]
In-Reply-To: <20111130161555.GB25812@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
 <20111129131110.GC19157@redhat.com> <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
 <20111129151607.GE30966@redhat.com> <CAK=WgbZK+k4uuyMPHUfr_PMyrR5ceRTvuDRpmhXfgwpSUOPw0g@mail.gmail.com>
 <20111130145958.GE21413@redhat.com> <CAK=WgbYyFdLftE_kp2_JOThVhn-FzGsDqVqKn0Jwm2teQyZBNA@mail.gmail.com>
 <20111130161555.GB25812@redhat.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 30 Nov 2011 18:24:16 +0200
Message-ID: <CAK=WgbazBq4GVo16sZsrZirgMYbwMcWtPaqn90c6d9Phr0gh3A@mail.gmail.com>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 6:15 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> How are the rings mapped? normal memory, right?

No, device memory.

> We allocate them with plan alloc_pages_exact in virtio_pci.c ...

I'm not using virtio_pci.c; remoteproc is allocating the rings using
the DMA API.

> Yes wmb() is required to ensure ordering for MMIO.
> But here both accesses: index and ring - are for
> memory, not MMIO.

I'm doing IO with a device over shared memory. It does require
mandatory barriers as I explained.

> Is this something you see in practice?

Yes. These bugs are very real.
