Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0GZOak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 10:30:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab0GZOaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 10:30:39 -0400
Date: Mon, 26 Jul 2010 10:30:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, nauman@google.com, dpshah@google.com,
        guijianfeng@cn.fujitsu.com, jmoyer@redhat.com
Subject: Re: [RFC PATCH] cfq-iosced: Implement IOPS mode and group_idle
 tunable V3
Message-ID: <20100726143023.GF12449@redhat.com>
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
 <20100722055602.GA18566@infradead.org>
 <20100722140044.GA28684@redhat.com>
 <20100724085135.GB32006@infradead.org>
 <AANLkTi=d-2-1R_Bpk_1J7AXhTc2Kv3p8S7tE0ZsFKFDe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=d-2-1R_Bpk_1J7AXhTc2Kv3p8S7tE0ZsFKFDe@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 24, 2010 at 11:07:07AM +0200, Corrado Zoccolo wrote:
> On Sat, Jul 24, 2010 at 10:51 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > To me this sounds like slice_idle=0 is the right default then, as it
> > gives useful behaviour for all systems linux runs on.
> No, it will give bad performance on single disks, possibly worse than
> deadline (deadline at least sorts the requests between different
> queues, while CFQ with slice_idle=0 doesn't even do this for readers).

> Setting slice_idle to 0 should be considered only when a single
> sequential reader cannot saturate the disk bandwidth, and this happens
> only on smart enough hardware with large number of spindles.

I was thinking of writting a user space utility which can launch
increasing number of parallel direct/buffered reads from device and if
device can sustain more than 1 parallel reads with increasing throughput,
then it probably is good indicator that one might be better off with
slice_idle=0.

Will try that today...

Vivek
