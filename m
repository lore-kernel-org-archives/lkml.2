Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab2IMIxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:53:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:40438 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2IMIxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:53:47 -0400
Message-ID: <1347526421.15764.112.camel@twins>
Subject: Re: [RFC] sched: nohz_idle_balance
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, mingo@redhat.com,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 13 Sep 2012 10:53:41 +0200
In-Reply-To: <1347525949.15764.109.camel@twins>
References: <1347509486-8688-1-git-send-email-vincent.guittot@linaro.org>
	 <1347518991.6821.45.camel@marge.simpson.net>
	 <CAKfTPtBQ7Y1xGOe9NZw8AhNbOzGgkVMgYyXjVa1d308kdG6bfQ@mail.gmail.com>
	 <1347521382.6821.61.camel@marge.simpson.net>
	 <CAKfTPtCvg1qxUv02-dO9qD2HiFzS_bA2Gr0mrN=8LEA3eXA7Bg@mail.gmail.com>
	 <1347522994.6821.67.camel@marge.simpson.net>
	 <CAKfTPtCoYjiZphPqyYtmEN-jR=hbAUMLbWSkD9BoWRiVkmE=3Q@mail.gmail.com>
	 <1347525949.15764.109.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 10:45 +0200, Peter Zijlstra wrote:
> On Thu, 2012-09-13 at 10:37 +0200, Vincent Guittot wrote:
> > > I think you need to present numbers showing benefit.  Crawling all over
> > > a mostly idle (4096p?) box is decidedly bad thing to do. 
> 
> Yeah, but we're already doing that anyway.. we know nohz idle balance
> doesn't scale. Venki and Suresh were working on that, but with Venki
> switching jobs this work got dropped.
> 
> I did talk to Suresh about it a week or so ago.. I think he was going to
> look at it again.

As a reminder to Suresh.. please also consider calc_load_{idle,idx} in
this work, its another nohz 'feature' that doesn't scale for pretty much
the same reason.

That is, I'm fine with the initial patches not actually fixing that, but
the structure put in place for the ILB should allow for it.
