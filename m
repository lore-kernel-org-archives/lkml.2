Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990Ab1IKDs6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 23:48:58 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49616 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1IKDs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 23:48:57 -0400
Date: Sun, 11 Sep 2011 12:48:51 +0900
From: Tejun Heo <tj@kernel.org>
To: Thomas Tuttle <ttuttle@chromium.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, stable@kernel.org
Subject: Re: [PATCH v3] workqueue: lock cwq access in drain_workqueue
Message-ID: <20110911034851.GA6428@mtj.dyndns.org>
References: <20110911033042.GN29319@htj.dyndns.org>
 <20110911033953.GA23049@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110911033953.GA23049@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 11:39:53PM -0400, Thomas Tuttle wrote:
> Take cwq->gcwq->lock to avoid racing between drain_workqueue checking
> to make sure the workqueues are empty and cwq_dec_nr_in_flight
> decrementing and then incrementing nr_active when it activates a
> delayed work.
> 
> We discovered this when a corner case in one of our drivers resulted in
> us trying to destroy a workqueue in which the remaining work would
> always requeue itself again in the same workqueue.  We would hit this
> race condition and trip the BUG_ON on workqueue.c:3080.
> 
> Signed-off-by: Thomas Tuttle <ttuttle@chromium.org>
> Acked-by: Tejun Heo <tj@kernel.org>
> Cc: stable@kernel.org

Andrew, can you please route this patch through -mm?  korg is still
down and wq is unlikely to receive many more patches in this cycle.

Thank you.

-- 
tejun
