Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab2JISgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:36:01 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47109 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab2JISf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:35:57 -0400
MIME-Version: 1.0
In-Reply-To: <20121006073947.GA26538@gmail.com>
References: <CAPM31R+mT+g0qTGOVgC1QYJk3Ju-u06UpkBwx-4tHxeh89kD3w@mail.gmail.com>
 <CAPM31RLKEZ0xzPXYQc-pMGUesfkviQ5i0LZaJipWC8oY=J5-kg@mail.gmail.com> <20121006073947.GA26538@gmail.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 9 Oct 2012 11:35:25 -0700
Message-ID: <CAPM31RJhrPyrS5fiLpDHy3BG=453NTFRo+kJFPJOKV5sA8CJyA@mail.gmail.com>
Subject: Re: sched: per-entity load-tracking
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ben Segall <bsegall@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 6, 2012 at 12:39 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Paul Turner <pjt@google.com> wrote:
>
>> Peter:
>> The rebase to tip/master made interdiff angry enough that it wasn't
>> producing the right relative diffs for your stack.  Sorry :(
>
> Find below the diff between the two series, using 'quilt
> snapshot' and 'quilt diff --snapshot'.

So what I was looking to generate here were per-patch differences that
Peter could squash into his quilt stack directly.  I typically find
interdiff works quite well for this, with the exception of the
changelog.

>
> One quick stylistic note: instead of putting the
> update_cfs_rq_blocked_load() in the middle of the file, order
> functions naturally so that no prototypes are needed.

This is certainly a principle I agree with, and I'm not gun-shy about
moving things around to reduce this burden :)

However, in this case I think the prototype is preferable as this code
is right in the middle of the 'core' helper functions for fair.c which
naturally live at the top of the file.  Promoting the group scheduling
bits to remove this dependency would place them several hundred lines
down and be counter-productive towards this structure.

However, if you still feel strongly, it can certainly be done.

Thanks!

- Paul
