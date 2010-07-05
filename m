Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab0GEICQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:02:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:41301 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275Ab0GEICO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:02:14 -0400
Date: Mon, 5 Jul 2010 17:01:57 +0900
To: axboe@kernel.dk
Cc: fujita.tomonori@lab.ntt.co.jp, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] remove q->prepare_flush_fn hook
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C3181E8.8010802@kernel.dk>
References: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<4C3181E8.8010802@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100705170050Z.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 05 Jul 2010 17:01:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jul 2010 08:55:36 +0200
Jens Axboe <axboe@kernel.dk> wrote:

> On 2010-07-03 10:45, FUJITA Tomonori wrote:
> > This removes q->prepare_flush_fn. Except for ide and scsi, all the
> > users just mark flush requests. They can use REQ_FLUSH flag
> > instead.
> > 
> > SCSI and ide can use q->prep_rq_fn to build flush requests.
> > 
> > This can be applied to the block's for-2.6.36.
> 
> Thanks, applied.

Thanks,

looks like you applied the patches in a wrong order (breaks bisect).

At least, the first two patches need to be applied in order before the
rest:

[PATCH 1/9] block: introduce REQ_FLUSH flag
[PATCH 2/9] block: permit PREFLUSH and POSTFLUSH without prepare_flush_fn
