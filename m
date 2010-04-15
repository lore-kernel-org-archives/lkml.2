Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab0DONkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 09:40:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab0DONkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 09:40:18 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com,
       rickyb@google.com
Subject: Re: [PATCH 0/4] block: Per-partition block IO performance histograms
References: <20100415054057.15836.17897.stgit@austin.mtv.corp.google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 15 Apr 2010 09:40:03 -0400
In-Reply-To: <20100415054057.15836.17897.stgit@austin.mtv.corp.google.com>
	(Divyesh Shah's message of "Wed, 14 Apr 2010 22:43:43 -0700")
Message-ID: <x49zl14hm18.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divyesh Shah <dpshah@google.com> writes:

> The following patchset implements per partition 2-d histograms for IO to block
> devices. The 3 types of histograms added are:
>
> 1) request histograms - 2-d histogram of total request time in ms (queueing +
>    service) broken down by IO size (in bytes).
> 2) dma histograms - 2-d histogram of total service time in ms broken down by
>    IO size (in bytes).
> 3) seek histograms - 1-d histogram of seek distance
>
> All of these histograms are per-partition. The first 2 are further divided into
> separate read and write histograms. The buckets for these histograms are
> configurable via config options as well as at runtime (per-device).

Do you also keep track of statistics for the entire device?  The I/O
schedulers operate at the device level, not the partition level.

> These histograms have proven very valuable to us over the years to understand
> the seek distribution of IOs over our production machines, detect large
> queueing delays, find latency outliers, etc. by being used as part of an
> always-on monitoring system.
>
> They can be reset by writing any value to them which makes them useful for
> tests and debugging too.
>
> This was initially written by Edward Falk in 2006 and I've forward ported
> and improved it a few times it across kernel versions.
>
> He had also sent a very old version of this patchset (minus some features like
> runtime configurable buckets) back then to lkml - see
> http://lkml.indiana.edu/hypermail/linux/kernel/0611.1/2684.html
> Some of the reasons mentioned for not including these patches are given below.
>
> I'm requesting re-consideration for this patchset in light of the following
> arguments.
>
> 1) This can be done with blktrace too, why add another API?
[...]
> This is about 1.8% average throughput loss per thread.
> The extra cpu time spent with blktrace is in addition to this loss of
> throughput. This overhead will only go up on faster SSDs.

I don't see any analysis of the overhead of your patch set.  Would you
mind providing those numbers?

Thanks,
Jeff
