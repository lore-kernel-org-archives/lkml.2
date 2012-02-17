Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab2BQLnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 06:43:43 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38782 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2BQLnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 06:43:42 -0500
MIME-Version: 1.0
In-Reply-To: <1329349028.2293.190.camel@twins>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
 <20120202013826.20844.8708.stgit@kitami.mtv.corp.google.com> <1329349028.2293.190.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Fri, 17 Feb 2012 03:43:11 -0800
Message-ID: <CAPM31RLZGdL-KqyQo0cWAAS-O3W+=dBzBD3G2NRmNTS+sGbgXA@mail.gmail.com>
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

On Wed, Feb 15, 2012 at 3:37 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-02-01 at 17:38 -0800, Paul Turner wrote:
>> +       /*
>> +        * Use 1024us as the unit of measurement since it's a reasonable
>> +        * approximation of 1ms and fast to compute.
>> +        */
>> +       delta >>= 10;
>
> ns -> us ?, text talks about ms, slightly confusing

Yes, comment was incorrect; I'd noticed this also on a re-read -- it's fixed.

>
>> +       if (!delta)
>> +               return 0;
>> +       sa->last_runnable_update = now;
>> +
>> +       delta_w = sa->runnable_avg_period % 1024;
>
> so delta_w is the chunk of this p we already accounted.
>
>> +       if (delta + delta_w >= 1024) {
>
> if delta pushes us over 1024*1024 ns (~1ms) we roll a window.
>
>> +               /* period roll-over */
>> +               decayed = 1;
>> +
>> +               delta_w = 1024 - delta_w;
>
> The distance we need to reach the next window.
>
>> +               BUG_ON(delta_w > delta);
>
> somehow reading this code took forever, this suggests clarification,
> either through better variable names or more comments. Could also mean
> I'm a moron and should get more sleep or so :-)

No... this bit is definitely fiddly, I definitely got it wrong more
than once writing it down.  And then got it again wrong later when
"optimizing" :-).

It deserves more comments, I will add.
