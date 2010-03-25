Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab0CYTSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 15:18:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab0CYTSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 15:18:01 -0400
Date: Thu, 25 Mar 2010 20:15:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Blum <bblum@google.com>,
       Jiri Slaby <jirislaby@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] sched/cpusets fixes, more changes are needed
Message-ID: <20100325191554.GA19830@redhat.com>
References: <20100315090958.GA9116@redhat.com> <1269452296.5109.508.camel@twins> <20100324180912.GA21774@redhat.com> <1269512531.12097.67.camel@laptop> <20100325154616.GA9773@redhat.com> <20100325160243.GA11517@redhat.com> <20100325161008.GA11724@redhat.com> <1269538142.12097.87.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269538142.12097.87.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25, Peter Zijlstra wrote:
>
> Yeah, such a smaller patch might work too, but I was trying to remove
> some more of the complexity we grown.
>
> Being able to fully remove that TASK_WAKING check from task_rq_lock()
> and only have it in set_cpus_allowed_ptr() would reduce some fast-path
> logic.

OK. Agreed.

> You patch add a memory barrier and an unlock_wait(), which, while
> seemingly correct, are harder to parse than the modified locking.

Yes, lock + set WAKING + unlock is simpler and cleaner, but this
doesn't matter.

I think your patch should address all problems.

Oleg.

