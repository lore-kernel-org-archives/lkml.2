Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1FGOFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:05:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab1FGOFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:05:52 -0400
Date: Tue, 7 Jun 2011 16:03:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: RCU-protect __set_task_cpu() in set_task_cpu()
Message-ID: <20110607140359.GA5497@redhat.com>
References: <20110531172651.GA4478@swordfish.minsk.epam.com> <1307115427.2353.3456.camel@twins> <20110605191233.GA20462@redhat.com> <1307351198.2353.7415.camel@twins> <20110606164657.GA20752@redhat.com> <1307439107.2322.229.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307439107.2322.229.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07, Peter Zijlstra wrote:
>
>     Cure this by passing the migration state in wake_flags. Also move the
>     whole test under CONFIG_SMP, its hard to migrate tasks on UP :-)


Agreed, WF_MIGRATE looks better. and "move under CONFIG_SMP" is probably
correct ;)

I still think it makes sense to move task_cpu(p) from try_to_wake_up() to
ttwu_stat(), just because it looks confusing. But this is very minor,
please forget.

Oleg.

