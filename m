Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1IFPC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:02:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257Ab1IFPCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:02:21 -0400
Subject: Re: [PATCH 2/3] define ARM-specific dma_coherent_write_sync
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: ming.lei@canonical.com, stern@rowland.harvard.edu,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Tue, 06 Sep 2011 11:02:10 -0400
In-Reply-To: <CAHkRjk6TD4Qg-b3nkCE_wwj-tWr-_5evndxo3f+_6gtXEV6gNg@mail.gmail.com>
References: <1314826214-22428-1-git-send-email-msalter@redhat.com>
	 <1314826214-22428-3-git-send-email-msalter@redhat.com>
	 <CAHkRjk7ZMDQh8sYf7N_4LLS12JU2ps8dkC34gNWNH+-Zp0p8Rg@mail.gmail.com>
	 <1315319837.2313.1.camel@deneb.redhat.com>
	 <CAHkRjk6TD4Qg-b3nkCE_wwj-tWr-_5evndxo3f+_6gtXEV6gNg@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1315321331.2313.10.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-06 at 15:48 +0100, Catalin Marinas wrote:
> On 6 September 2011 15:37, Mark Salter <msalter@redhat.com> wrote:
> > On Tue, 2011-09-06 at 15:32 +0100, Catalin Marinas wrote:
> >> That's what mb() and wmb() do already, at least on ARM. Why do we need
> >> another API? IIRC from past discussions on linux-arch around barriers,
> >> the mb() should be sufficient in the case of DMA coherent buffers.
> >> That's why macros like writel() on ARM have the mb() added by default
> >> (for cases where you start the DMA transfer by writing to a device
> >> register).
> >
> > For USB EHCI, the driver does not necessarily write to a register after
> > writing to DMA coherent memory. In some cases, the controller polls for
> > information written by the driver.
> 
> So as I understand, you would like to force the eviction from the
> write buffer rather than waiting for it to be drained. On ARM, the
> write buffer is eventually flushed, so there is no strict timing
> guarantee. It could take longer if the processor immediately starts
> polling some memory location for example, but in this case a simple
> barrier would do.

Yes, a memory barrier would have the same effect on ARM, but the
purpose of a barrier is to guarantee ordering. What the patch does
is add an interface to force a write buffer flush for performance,
not ordering. If a memory barrier is used, it could have a negative
impact on other arches.

In any case, the current thinking is that the original problem with
the USB performance seen on cortex A9 multicore is probably something
more than just write buffer delays. Once the original problem is better
understood, we can take another look at this patch if it is still
needed.

--Mark



