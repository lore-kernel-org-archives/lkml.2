Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab0DWISP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:18:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:54122 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab0DWISM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:18:12 -0400
Message-ID: <4BD1576E.5070401@kernel.org>
Date: Fri, 23 Apr 2010 10:16:46 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 7/9] PM: Add suspend blocking work.
References: <1271984938-13920-1-git-send-email-arve@android.com> <1271984938-13920-2-git-send-email-arve@android.com> <1271984938-13920-3-git-send-email-arve@android.com> <1271984938-13920-4-git-send-email-arve@android.com> <1271984938-13920-5-git-send-email-arve@android.com> <1271984938-13920-6-git-send-email-arve@android.com> <1271984938-13920-7-git-send-email-arve@android.com> <1271984938-13920-8-git-send-email-arve@android.com>
In-Reply-To: <1271984938-13920-8-git-send-email-arve@android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Apr 2010 08:16:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/23/2010 03:08 AM, Arve Hjønnevåg wrote:
> Allow work to be queued that will block suspend while it is pending
> or executing. To get the same functionality in the calling code often
> requires a separate suspend_blocker for pending and executing work, or
> additional state and locking.

Hmm... I think this can be implemented as pure wrapper around
workqueue instead of injecting a flag and code into workqueue core.
Adding @fn field to suspend_blocking_work struct and using a custom
work function to call it and then invoke suspend_unblock() should be
enough, right?  Oh, dedicated queue functions will be needed too.  I
don't think it's wise to meddle with workqueue core code for this.

Thanks.

-- 
tejun
