Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab1FVAq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 20:46:26 -0400
Received: from sous-sol.org ([216.99.217.87]:51877 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757434Ab1FVAqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 20:46:24 -0400
Date: Tue, 21 Jun 2011 17:46:08 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Nai Xia <nai.xia@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2 V2] ksm: take dirty bit as reference to avoid
 volatile pages scanning
Message-ID: <20110622004608.GS25383@sequoia.sous-sol.org>
References: <201106212055.25400.nai.xia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106212055.25400.nai.xia@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nai Xia (nai.xia@gmail.com) wrote:
> Compared to the first version, this patch set addresses the problem of
> dirty bit updating of virtual machines, by adding two mmu_notifier interfaces.
> So it can now track the volatile working set inside KVM guest OS.
> 
> V1 log:
> Currently, ksm uses page checksum to detect volatile pages. Izik Eidus 
> suggested that we could use pte dirty bit to optimize. This patch series
> adds this new logic.
> 
> Preliminary benchmarks show that the scan speed is improved by up to 16 
> times on volatile transparent huge pages and up to 8 times on volatile 
> regular pages.

Did you run this only in the host (which would not trigger the notifiers
to kvm), or also run your test program in a guest?

thanks,
-chris
