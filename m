Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817Ab2FUIek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:34:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:45680 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758798Ab2FUIei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:34:38 -0400
Message-ID: <1340267659.21745.157.camel@twins>
Subject: Re: [PATCH v3] sched: balance_cpu to consider other cpus in its
 group as target of (pinned) task
From: Peter Zijlstra <peterz@infradead.org>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org, efault@gmx.de,
        Ingo Molnar <mingo@elte.hu>
Date: Thu, 21 Jun 2012 10:34:19 +0200
In-Reply-To: <20120621034059.GA9748@linux.vnet.ibm.com>
References: <4FE06CDB.2060605@linux.vnet.ibm.com>
	 <1340213901.21745.122.camel@twins>
	 <20120621034059.GA9748@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 09:10 +0530, Srivatsa Vaddagiri wrote:

> Hmm ..I can see loop_break being incremented here:
> 
>                 /* take a breather every nr_migrate tasks */
>                 if (env->loop > env->loop_break) {
>                         env->loop_break += sched_nr_migrate_break;
>                         env->flags |= LBF_NEED_BREAK;
>                         goto out;
>                 }
> 
> As a result, when we redo with a different src_cpu, both loop and
> loop_break could be at non-default values.  Am I missing something here?

D'0h right you are.. /me quickly edits patch again.

I thought I removed all that, guess I didn't.
