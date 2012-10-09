Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab2JINhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:37:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:61262 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab2JINhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:37:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,560,1344236400"; 
   d="scan'208";a="224216228"
From: Andi Kleen <andi@firstfloor.org>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, <linux-serial@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [REPOST] RFC: sched: Prevent wakeup to enter critical section needlessly
References: <1348491997-30898-1-git-send-email-meltedpianoman@gmail.com>
	<1349782235-8896-1-git-send-email-meltedpianoman@gmail.com>
Date: Tue, 09 Oct 2012 06:37:27 -0700
In-Reply-To: <1349782235-8896-1-git-send-email-meltedpianoman@gmail.com> (Ivo
	Sieben's message of "Tue, 9 Oct 2012 13:30:35 +0200")
Message-ID: <m2r4p7u5pk.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivo Sieben <meltedpianoman@gmail.com> writes:

> Check the waitqueue task list to be non empty before entering the critical
> section. This prevents locking the spin lock needlessly in case the queue
> was empty, and therefor also prevent scheduling overhead on a PREEMPT_RT
> system.
>
> Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
> ---
>
>  REPOST:
>  Request for comments:
>  - Does this make any sense?

Looks good to me. Avoiding any spinlock is good.  I don't even think you
need "careful", if you miss an update it was just as it happened a
little later.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
