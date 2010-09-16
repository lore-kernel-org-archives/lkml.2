Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab0IPDpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 23:45:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60654 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752386Ab0IPDpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 23:45:15 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19jtUE2R89jXarxjR1kIaNXYZHzElaoG4F+YI4DF7
	lWbBeka9bvWoCw
Subject: Re: 2.6.32.y stable kernel regression with taskset
From: Mike Galbraith <efault@gmx.de>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Wright <john.wright@hp.com>
In-Reply-To: <4C9114A6.6040500@oracle.com>
References: <4C9114A6.6040500@oracle.com>
Content-Type: text/plain
Date: Thu, 16 Sep 2010 05:45:12 +0200
Message-Id: <1284608712.7403.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 11:47 -0700, Yinghai Lu wrote:
> found problem with cpuscaling test.
> 
> Under 2.6.32.21   Userspace gov  
> min freq load test time is nearly the same as max freq load test time around  ~16 seconds
> 
> under 2.6.18-194
> min freq load test time is ~40 seconds
> max freq load test time	  is ~ 17 seconds
> 
> the test is 
> 1. set governor for one cpu to userspace
> 2. set freq to min for that cpu
> 3. using taskset to put load test only on that cpu, and get the time for load test.
> 
> so that mean taskset did not put load test on cpu that we want. and other cpu still have ondemand governor and load test get done much faster
> 
> git bisect report:
> 
> c6fc81afa2d7ef2f775e48672693d8a0a8a7325d is the first bad commit
> commit c6fc81afa2d7ef2f775e48672693d8a0a8a7325d
> Author: John Wright <john.wright@hp.com>
> Date:   Tue Apr 13 16:55:37 2010 -0600
> 
>     sched: Fix a race between ttwu() and migrate_task()

Known issue.  There's a sched series for 32-stable in the pipeline.

	-Mike

