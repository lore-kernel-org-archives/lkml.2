Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab0JOQUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 12:20:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12623 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab0JOQUv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:20:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dpLTZJaBk7vKWd5Qw1BSJDB9QvMIAARtnO9WQlRcrwCxWWXRCFe7YVEdyKwleMS9pE
         /zcJBM85ImdiIY3J0AQQ==
MIME-Version: 1.0
In-Reply-To: <1287144482.29097.1463.camel@twins>
References: <1286996978-7007-1-git-send-email-ncrao@google.com>
 <1286996978-7007-5-git-send-email-ncrao@google.com> <1287144482.29097.1463.camel@twins>
From: Nikhil Rao <ncrao@google.com>
Date: Fri, 15 Oct 2010 09:20:27 -0700
Message-ID: <AANLkTimFp8MhnWf+ztK5NRzVvAJ3Qbn2mU6WD-Wz4yGp@mail.gmail.com>
Subject: Re: [PATCH 4/4] sched: force balancing on newidle balance if local
 group has capacity
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 5:08 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-10-13 at 12:09 -0700, Nikhil Rao wrote:
>> @@ -2824,6 +2845,10 @@ find_busiest_group(struct sched_domain *sd, int
>> this_cpu,
>>         if (!sds.busiest || sds.busiest_nr_running == 0)
>>                 goto out_balanced;
>>
>> +       /*  SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
>> +       if (idle == CPU_NEWLY_IDLE && check_utilization(&sds))
>> +               goto force_balance;
>
>
> There's a large comment a few lines up from here that tries to explain
> all these funny reasons for not balancing, that wants updating too.
>

Will do.
