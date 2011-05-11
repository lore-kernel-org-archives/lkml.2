Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1EKRhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:37:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:63787 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab1EKRhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:37:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,353,1301900400"; 
   d="scan'208";a="974459"
From: Andi Kleen <andi@firstfloor.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
References: <1305073386-4810-1-git-send-email-john.stultz@linaro.org>
	<1305073386-4810-3-git-send-email-john.stultz@linaro.org>
Date: Wed, 11 May 2011 10:36:54 -0700
In-Reply-To: <1305073386-4810-3-git-send-email-john.stultz@linaro.org> (John
	Stultz's message of "Tue, 10 May 2011 17:23:05 -0700")
Message-ID: <m2sjsli1ft.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz <john.stultz@linaro.org> writes:

> Acessing task->comm requires proper locking. However in the past
> access to current->comm could be done without locking. This
> is no longer the case, so all comm access needs to be done
> while holding the comm_lock.
>
> In my attempt to clean up unprotected comm access, I've noticed
> most comm access is done for printk output. To simpify correct
> locking in these cases, I've introduced a new %ptc format,
> which will safely print the corresponding task's comm.
>
> Example use:
> printk("%ptc: unaligned epc - sending SIGBUS.\n", current);

Neat. But you probably want a checkpatch rule for this too
to catch new offenders.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
