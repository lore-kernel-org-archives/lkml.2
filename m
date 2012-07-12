Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161388Ab2GLRG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:06:26 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50580 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab2GLRGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:06:24 -0400
Date: Thu, 12 Jul 2012 10:06:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        joshhunt00@gmail.com, axboe@kernel.dk, rni@google.com,
        vgoyal@redhat.com, vwadekar@nvidia.com, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org, swhiteho@redhat.com,
        bpm@sgi.com, elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 3/6] workqueue: use @pool instead of @gcwq or @cpu
 where applicable
Message-ID: <20120712170618.GB20167@google.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
 <1341859315-17759-4-git-send-email-tj@kernel.org>
 <CA+8MBbKtCODJxv0zQ2uL_wRE9U6F6tdOVwYSMv9=OQNLGzcVXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbKtCODJxv0zQ2uL_wRE9U6F6tdOVwYSMv9=OQNLGzcVXQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tony.

On Tue, Jul 10, 2012 at 04:30:36PM -0700, Tony Luck wrote:
> On Mon, Jul 9, 2012 at 11:41 AM, Tejun Heo <tj@kernel.org> wrote:
> > @@ -1234,7 +1235,7 @@ static void worker_enter_idle(struct worker *worker)
> >          */
> >         WARN_ON_ONCE(gcwq->trustee_state == TRUSTEE_DONE &&
> >                      pool->nr_workers == pool->nr_idle &&
> > -                    atomic_read(get_gcwq_nr_running(gcwq->cpu)));
> > +                    atomic_read(get_pool_nr_running(pool)));
> >  }
> 
> Just had this WARN_ON_ONCE trigger on ia64 booting next-20120710. I
> haven't bisected ... just noticed  that two patches in this series tinker
> with lines in this check. next-20120706 didn't generate the WARN.

Sorry about the delay.  The warning is spurious.  As now there are
multiple pools, nr_running check should be done before
pool->nr_workers check.  Will post fix soon.

Thank you.

-- 
tejun
