Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab2BQKz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 05:55:27 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52716 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab2BQKzZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 05:55:25 -0500
MIME-Version: 1.0
In-Reply-To: <1329399446.2293.217.camel@twins>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
 <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com> <1329399446.2293.217.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Fri, 17 Feb 2012 02:54:55 -0800
Message-ID: <CAPM31RLKvmRr_76B12zTnqh6+htm++hmSiM9O3EsuRd47oFtpw@mail.gmail.com>
Subject: Re: [RFC PATCH 14/14] sched: implement usage tracking
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 5:37 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-02-01 at 17:38 -0800, Paul Turner wrote:
>>  static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
>>  {
>> -       __update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable);
>> +       __update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable,
>> +                                    runnable);
>
> Its not immediately obvious why we use @runnable for @running,

Isn't it?  An rq is the root of all scheduling -- if there are any
runnable tasks than one of them better be running when this is called.

I can add a comment to this effect.
