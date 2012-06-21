Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab2FUFZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 01:25:34 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41689 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab2FUFZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 01:25:33 -0400
Message-ID: <4FE2B013.7090108@linux.vnet.ibm.com>
Date: Thu, 21 Jun 2012 10:54:35 +0530
From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org, efault@gmx.de,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task
References: <4FE06CDB.2060605@linux.vnet.ibm.com> <1340213901.21745.122.camel@twins> <20120621034059.GA9748@linux.vnet.ibm.com> <20120621042347.GA5059@linux.vnet.ibm.com>
In-Reply-To: <20120621042347.GA5059@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062105-6078-0000-0000-00000C56D225
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 09:53 AM, Srivatsa Vaddagiri wrote:

> * Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> [2012-06-21 09:10:59]:
> 
>> Hmm ..I can see loop_break being incremented here:
>>
>>                 /* take a breather every nr_migrate tasks */
>>                 if (env->loop > env->loop_break) {
>>                         env->loop_break += sched_nr_migrate_break;
> 
> One possibility is to reset env->loop here, rather than loop_break, in
> which case loop_break can remain constant across "redos" and
> "more_balances"

We cannot do this as env->loop is compared with env->loop_max. So, I
believe resetting env->loop_break along with env->loop before "redos"
and "more_balances" is the right thing to do.

- Prashanth

