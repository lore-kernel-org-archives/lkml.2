Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab1DZTvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:51:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756611Ab1DZTvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:51:13 -0400
Date: Tue, 26 Apr 2011 12:47:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Subject: Re: readahead and oom
Message-Id: <20110426124743.e58d9746.akpm@linux-foundation.org>
In-Reply-To: <20110426092029.GA27053@localhost>
References: <BANLkTin8mE=DLWma=U+CdJaQW03X2M2W1w@mail.gmail.com>
	<20110426055521.GA18473@localhost>
	<BANLkTik8k9A8N8CPk+eXo9c_syxJFRyFCA@mail.gmail.com>
	<BANLkTim0MNgqeh1KTfvpVFuAvebKyQV8Hg@mail.gmail.com>
	<20110426062535.GB19717@localhost>
	<BANLkTinM9DjK9QsGtN0Sh308rr+86UMF0A@mail.gmail.com>
	<20110426063421.GC19717@localhost>
	<BANLkTi=xDozFNBXNdGDLK6EwWrfHyBifQw@mail.gmail.com>
	<20110426092029.GA27053@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 17:20:29 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Pass __GFP_NORETRY|__GFP_NOWARN for readahead page allocations.
> 
> readahead page allocations are completely optional. They are OK to
> fail and in particular shall not trigger OOM on themselves.

I have distinct recollections of trying this many years ago, finding
that it caused problems then deciding not to do it.  But I can't find
an email trail and I don't remember the reasons :(

If the system is so stressed for memory that the oom-killer might get
involved then the readahead pages may well be getting reclaimed before
the application actually gets to use them.  But that's just an aside.

Ho hum.  The patch *seems* good (as it did 5-10 years ago ;)) but there
may be surprising side-effects which could be exposed under heavy
testing.  Testing which I'm sure hasn't been performed...


