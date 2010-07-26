Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0GZOdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 10:33:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab0GZOdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 10:33:13 -0400
Date: Mon, 26 Jul 2010 10:33:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, nauman@google.com, dpshah@google.com,
        guijianfeng@cn.fujitsu.com, jmoyer@redhat.com
Subject: Re: [RFC PATCH] cfq-iosced: Implement IOPS mode and group_idle
 tunable V3
Message-ID: <20100726143300.GG12449@redhat.com>
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

Not sure if CFQ will be worse than deadline with slice_idle=0. CFQ has
some inbuilt things which should help.

- Readers preempt Writers
- All writers go in one single queue (at one prio level), readers get
  their individual queues and can outnumber writers.

So I guess CFQ with slice_idle=0 should not be worse than deadline in terms
of read latencies.

Vivek
