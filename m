Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab0D3Ruw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:50:52 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:53923 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758686Ab0D3Rug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:50:36 -0400
Date: Wed, 28 Apr 2010 08:06:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj??nnev??g <arve@android.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 6/8] PM: Add suspend blocking work.
Message-ID: <20100428060659.GC3721@ucw.cz>
References: <1272429119-12103-1-git-send-email-arve@android.com>
 <1272429119-12103-2-git-send-email-arve@android.com>
 <1272429119-12103-3-git-send-email-arve@android.com>
 <1272429119-12103-4-git-send-email-arve@android.com>
 <1272429119-12103-5-git-send-email-arve@android.com>
 <1272429119-12103-6-git-send-email-arve@android.com>
 <1272429119-12103-7-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272429119-12103-7-git-send-email-arve@android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Allow work to be queued that will block suspend while it is pending
> or executing. To get the same functionality in the calling code often
> requires a separate suspend_blocker for pending and executing work, or
> additional state and locking. This implementation does add additional
> state and locking, but this can be removed later if we add support for
> suspend blocking work to the core workqueue code.
> 
> Signed-off-by: Arve Hj??nnev??g <arve@android.com>

Seems sane. ACK.

> +struct suspend_blocking_work {
> +	struct work_struct work;
> +#ifdef CONFIG_OPPORTUNISTIC_SUSPEND

Cound we name it C_AUTO_SUSPEND... to reduce length and typo
potential?

> +	struct suspend_blocker suspend_blocker;
> +	work_func_t func;
> +	spinlock_t lock;
> +	int active;

Is the lock internal-use, or is API user allowed to use it?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
