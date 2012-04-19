Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab2DSP2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 11:28:47 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49188 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab2DSP2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 11:28:46 -0400
Date: Thu, 19 Apr 2012 08:28:41 -0700
From: Tejun Heo <tj@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 1/2] workqueue: Catch more locking problems with
 flush_work()
Message-ID: <20120419152841.GA10553@google.com>
References: <1334805958-29119-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334805958-29119-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 08:25:57PM -0700, Stephen Boyd wrote:
> @@ -2513,8 +2513,11 @@ bool flush_work(struct work_struct *work)
>  		wait_for_completion(&barr.done);
>  		destroy_work_on_stack(&barr.work);
>  		return true;
> -	} else
> +	} else {
> +		lock_map_acquire(&work->lockdep_map);
> +		lock_map_release(&work->lockdep_map);
>  		return false;

We don't have this annotation when start_flush_work() succeeds either,
right?  IOW, would lockdep trigger when an actual deadlock happens?
If not, why not add the acquire/release() before flush_work() does
anything?

Thanks.

-- 
tejun
