Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab2DEOL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:11:56 -0400
Received: from smtprelay02.ispgateway.de ([80.67.29.24]:60238 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2DEOLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:11:55 -0400
X-Greylist: delayed 113261 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2012 10:11:55 EDT
Message-ID: <4F7DA8FD.1020909@ladisch.de>
Date: Thu, 05 Apr 2012 16:15:25 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
CC: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: semaphore and mutex in current Linux kernel (3.2.2)
References: <491D6B4EAD0A714894D8AD22F4BDE0439F94AB@SCYBEXDAG02.amd.com> <20120401121943.GA11893@gmail.com> <491D6B4EAD0A714894D8AD22F4BDE0439F9560@SCYBEXDAG02.amd.com> <20120403075245.GD26826@gmail.com> <491D6B4EAD0A714894D8AD22F4BDE0439F98F4@SCYBEXDAG02.amd.com>
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE0439F98F4@SCYBEXDAG02.amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen, Dennis (SRDC SW) wrote:
> I know that the rationale of the mutex's optimization is, if the lock owner is
> running, it's likely to release the lock soon. So make the waiter to spin a
> short time waiting for the lock to be released is reasonable given the workload
> of a process switch.
>
> But how about if the lock owner running doesn't release the lock soon?

It would not make sense to spin too long, especially if some other
process wants to run on the same CPU.

> int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
> {
> 	...
> 	while (owner_running(lock, owner)) {
> 		if (need_resched())
> 			break;
>
> 		arch_mutex_cpu_relax();
> 	}
> 	...
> }
>
> [experiment]
>
> D+ means the App in CPU1 is sleeping in a UNINTERRUPTIBLE state. This is very interesting,
> How does this happen?

Your experiment shows that there must be some condition that makes the
code break out of the spin loop ...


Regards,
Clemens
