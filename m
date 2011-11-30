Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab1K3O6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:58:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757112Ab1K3O6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:58:22 -0500
Date: Wed, 30 Nov 2011 16:59:59 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
Message-ID: <20111130145958.GE21413@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
 <20111129131110.GC19157@redhat.com>
 <CAK=WgbZoGYVyKt=XXvnPVdh0koSBJC0zcgkLaYRkmjwBLOFA-A@mail.gmail.com>
 <20111129151607.GE30966@redhat.com>
 <CAK=WgbZK+k4uuyMPHUfr_PMyrR5ceRTvuDRpmhXfgwpSUOPw0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=WgbZK+k4uuyMPHUfr_PMyrR5ceRTvuDRpmhXfgwpSUOPw0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 01:45:05PM +0200, Ohad Ben-Cohen wrote:
> > So you put virtio rings in MMIO memory?
> 
> I'll be precise: the vrings are created in non-cacheable memory, which
> both processors have access to.
> 
> > Could you please give a couple of examples of breakage?
> 
> Sure. Basically, the order of the vring memory operations appear
> differently to the observing processor. For example, avail->idx gets
> updated before the new entry is put in the available array...

I see. And this happens because the ARM processor reorders
memory writes to this uncacheable memory?
And in an SMP configuration, writes are somehow not reordered?

For example, if we had such an AMP configuration with and x86
processor, wmb() (sfence) would be wrong and smp_wmb() would be sufficient.

Just checking that this is not a bug in the smp_wmb implementation
for the specific platform.

-- 
MST
