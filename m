Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1LDKuN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 05:50:13 -0500
Received: from ozlabs.org ([203.10.76.45]:60424 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182Ab1LDKuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 05:50:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
In-Reply-To: <1322867384.11728.20.camel@pasglop>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com> <1322867384.11728.20.camel@pasglop>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sat, 03 Dec 2011 15:44:36 +1030
Message-ID: <87hb1iqls3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Dec 2011 10:09:44 +1100, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Tue, 2011-11-29 at 14:31 +0200, Ohad Ben-Cohen wrote:
> > A trivial, albeit sub-optimal, solution would be to simply revert
> > commit d57ed95 "virtio: use smp_XX barriers on SMP". Obviously, though,
> > that's going to have a negative impact on performance of SMP-based
> > virtualization use cases.
> 
> Have you measured the impact of using normal barriers (non-SMP ones)
> like we use on normal HW drivers unconditionally ?
> 
> IE. If the difference is small enough I'd say just go for it and avoid
> the bloat.

Yep.  Plan is:
1) Measure the difference.
2) Difference unmeassurable?  Use normal barriers (ie. revert d57ed95).
3) Difference small?  Revert d57ed95 for 3.2, revisit for 3.3.
4) Difference large?  Runtime switch based on "if you're PCI" for 3.2,
   revisit for 3.3.

Cheers,
Rusty.
