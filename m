Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1LBXKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:10:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:52632 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab1LBXKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:10:10 -0500
Message-ID: <1322867384.11728.20.camel@pasglop>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 03 Dec 2011 10:09:44 +1100
In-Reply-To: <1322569886-13055-1-git-send-email-ohad@wizery.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 14:31 +0200, Ohad Ben-Cohen wrote:
> Virtio is using memory barriers to control the ordering of
> references to the vrings on SMP systems. When the guest is compiled
> with SMP support, virtio is only using SMP barriers in order to
> avoid incurring the overhead involved with mandatory barriers.
> 
> Lately, though, virtio is being increasingly used with inter-processor
> communication scenarios too, which involve running two (separate)
> instances of operating systems on two (separate) processors, each of
> which might either be UP or SMP.
> 
> To control the ordering of memory references when the vrings are shared
> between two external processors, we must always use mandatory barriers.
> 
> A trivial, albeit sub-optimal, solution would be to simply revert
> commit d57ed95 "virtio: use smp_XX barriers on SMP". Obviously, though,
> that's going to have a negative impact on performance of SMP-based
> virtualization use cases.

Have you measured the impact of using normal barriers (non-SMP ones)
like we use on normal HW drivers unconditionally ?

IE. If the difference is small enough I'd say just go for it and avoid
the bloat.

Ben.


