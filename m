Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab2BQLoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 06:44:37 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49825 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2BQLog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 06:44:36 -0500
MIME-Version: 1.0
In-Reply-To: <1329398878.2293.215.camel@twins>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
 <20120202013826.20844.8708.stgit@kitami.mtv.corp.google.com> <1329398878.2293.215.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Fri, 17 Feb 2012 03:44:05 -0800
Message-ID: <CAPM31RKkh73tKfDyT25ayS3qN1pv3jcNVfNoso2qRAwS2X3Y=g@mail.gmail.com>
Subject: Re: [RFC PATCH 01/14] sched: track the runnable average on a per-task
 entitiy basis
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

On Thu, Feb 16, 2012 at 5:27 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-02-01 at 17:38 -0800, Paul Turner wrote:
>> +static __always_inline u64 decay_load(u64 val, int n)
>> +{
>> +       for (;n && val;n--) {
>> +               val *= 4008;
>> +               val >>= 12;
>> +       }
>> +
>> +       return val;
>> +}
>
>> +                       sa->runnable_avg_sum =
>> +                               decay_load(sa->runnable_avg_sum, 1);
>> +                       sa->runnable_avg_period =
>> +                               decay_load(sa->runnable_avg_period, 1);
>
> Since all you ever seem to do is:
>
>  x = decay(x, n);
>
> and frequently run over the line limits it might make sense to either
> introduce a CPP helper or make the first argument a pointer and ditch
> the return value so we end up with something like:
>
>  decay(&x, n);

Ah-ha, good idea.  I had done some other fiddles to try and make
things fit better, but this will work.

Thanks!
