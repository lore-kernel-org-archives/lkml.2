Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab1IKDav (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 23:30:51 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49601 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab1IKDau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 23:30:50 -0400
Date: Sun, 11 Sep 2011 12:30:42 +0900
From: Tejun Heo <tj@kernel.org>
To: Thomas Tuttle <ttuttle@chromium.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] workqueue: lock cwq access in drain_workqueue
Message-ID: <20110911033042.GN29319@htj.dyndns.org>
References: <20110909152222.GA14705@google.com>
 <20110909230053.GA28394@google.com>
 <20110911013549.GI29319@htj.dyndns.org>
 <20110911032641.GA22325@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110911032641.GA22325@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Sep 10, 2011 at 11:26:41PM -0400, Thomas Tuttle wrote:
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

  Acked-by: Tejun Heo <tj@kernel.org>

Can you please also add "Cc: stable@kernel.org" and send it to Andrew
Morton <akpm@linux-foundation.org>?

Thank you very much.

-- 
tejun
