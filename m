Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab1EDDw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 23:52:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:27538 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab1EDDw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 23:52:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,312,1301900400"; 
   d="scan'208";a="430042685"
From: Andi Kleen <andi@firstfloor.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] time: Add locking to xtime access in get_seconds()
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>
Date: Tue, 03 May 2011 20:52:46 -0700
In-Reply-To: <1304478708-1273-1-git-send-email-john.stultz@linaro.org> (John
	Stultz's message of "Tue, 3 May 2011 20:11:48 -0700")
Message-ID: <m2oc3jxgtt.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz <john.stultz@linaro.org> writes:

> From: John Stultz <johnstul@us.ibm.com>
>
> So get_seconds() has always been lock free, with the assumption
> that accessing a long will be atomic.
>
> However, recently I came across an odd bug where time() access could
> occasionally be inconsistent, but only on power7 hardware. The

Shouldn't a single rmb() be enough to avoid that?

If not then I suspect there's a lot more code buggy on that CPU than
just the time.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
