Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab2FYR0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:26:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62463 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab2FYR0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:26:04 -0400
Date: Mon, 25 Jun 2012 10:26:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Josh Hunt <joshhunt00@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: multi-second application stall in open()
Message-ID: <20120625172600.GB3869@google.com>
References: <20120621203217.GC14095@redhat.com>
 <CAKA=qzYmh8DD7J__WWDyX_2fFQbSx+M=k4ttqRTD3M8nao-WVg@mail.gmail.com>
 <20120622141211.GB18409@redhat.com>
 <CAKA=qzYYK5KUNsZ1C7Z7BEkqo-7uvn=HYr0N9KLPaLt9ut+MDQ@mail.gmail.com>
 <CAKA=qzY+u64vVZmbiH4zp_Fij2zejQBFUSNENKF=PZBT0G7xrQ@mail.gmail.com>
 <20120622204207.GA22063@redhat.com>
 <CAKA=qzbycm0cjLyiuKaKkD8sxDm5DvX9WVqSxN2QVT2WZOzU0Q@mail.gmail.com>
 <CAKA=qza_s6zr+wZzfFTVPSzgPQAov=K63jf-SJOTDcrnDELY5w@mail.gmail.com>
 <CAKA=qzYea71A5VQOQgrqzaZtVFadjhcghgH+Z9n4ivS7vUgW0g@mail.gmail.com>
 <20120625133047.GA9394@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120625133047.GA9394@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 09:30:47AM -0400, Vivek Goyal wrote:
> In slice_expired() we can probably put a BUG_ON() which checks following.
> 
> BUG_ON(RB_EMPTY_ROOT(&cfqq->sort_list) && (cfqq->queued[0] || cfqq->queued[1]));

Nit: Please use WARN_ON_ONCE() instead.  Multi-sec stalls tend to be
better than panic. :)

-- 
tejun
