Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab0IPOlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:41:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287Ab0IPOlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:41:46 -0400
Date: Thu, 16 Sep 2010 07:42:16 -0700
From: Greg KH <gregkh@suse.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Yinghai Lu <yinghai.lu@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Wright <john.wright@hp.com>
Subject: Re: 2.6.32.y stable kernel regression with taskset
Message-ID: <20100916144216.GA4794@suse.de>
References: <4C9114A6.6040500@oracle.com> <1284608712.7403.10.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284608712.7403.10.camel@marge.simson.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 05:45:12AM +0200, Mike Galbraith wrote:
> On Wed, 2010-09-15 at 11:47 -0700, Yinghai Lu wrote:
> > found problem with cpuscaling test.
> > 
> > Under 2.6.32.21   Userspace gov  
> > min freq load test time is nearly the same as max freq load test time around  ~16 seconds
> > 
> > under 2.6.18-194
> > min freq load test time is ~40 seconds
> > max freq load test time	  is ~ 17 seconds
> > 
> > the test is 
> > 1. set governor for one cpu to userspace
> > 2. set freq to min for that cpu
> > 3. using taskset to put load test only on that cpu, and get the time for load test.
> > 
> > so that mean taskset did not put load test on cpu that we want. and other cpu still have ondemand governor and load test get done much faster
> > 
> > git bisect report:
> > 
> > c6fc81afa2d7ef2f775e48672693d8a0a8a7325d is the first bad commit
> > commit c6fc81afa2d7ef2f775e48672693d8a0a8a7325d
> > Author: John Wright <john.wright@hp.com>
> > Date:   Tue Apr 13 16:55:37 2010 -0600
> > 
> >     sched: Fix a race between ttwu() and migrate_task()
> 
> Known issue.  There's a sched series for 32-stable in the pipeline.

Yes, sorry, I'm working my way through to them, hope to have them
finished and applied soon.

thanks,

greg k-h
