Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab0DAG24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 02:28:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:44919 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434Ab0DAG2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 02:28:50 -0400
Message-ID: <4BB43CF4.5020403@kernel.org>
Date: Thu, 01 Apr 2010 15:28:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch] workqueue: move lockdep annotations up to	destroy_workqueue()
References: <20100331105534.5601.50813.sendpatchset@localhost.localdomain> <20100331112559.GA17747@redhat.com> <4BB408AF.4080908@redhat.com> <4BB41988.1030400@kernel.org> <4BB41C72.3090909@redhat.com> <4BB41DAE.3010605@kernel.org> <4BB420D6.7050401@redhat.com> <4BB42822.30607@kernel.org> <4BB42D05.4060207@redhat.com> <4BB437B8.9060802@redhat.com>
In-Reply-To: <4BB437B8.9060802@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 01 Apr 2010 06:28:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/01/2010 03:05 PM, Cong Wang wrote:
>> Hmm, it looks like I misunderstand lock_map_acquire()? From the
>> changelog, I thought it was added to complain its caller is holding
>> a lock when invoking it, thus cpu_add_remove_lock is not an
>> exception.

Oh, that just tells the code is trying to grab a pseudo lock.  It's
not really a lock but to lockdep it looks like one and lockdep can use
it to compute problem cases.

> Oh, I see, wq->lockdep_map is acquired again in run_workqueue(), so
> I was wrong. :) I think you and Oleg are right, the lockdep warning
> is not irrelevant.

Yeah, I think the circular dependency you reported on wq->lockdep_map
is completed only through dependency through rtnl_mutex.  If you fix
rtnl_mutex locking, it should go away too.

Thanks.

-- 
tejun
