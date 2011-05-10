Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab1EJJHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:07:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37267 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab1EJJHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:07:41 -0400
Subject: Re: [PATCH] sched: fix erroneous sysct_sched_nr_migrate logic
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vladimir Davydov <VDavydov@parallels.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nikhil Rao <ncrao@google.com>, Mike Galbraith <efault@gmx.de>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
In-Reply-To: <9532E773-BD05-4A18-B9BD-6B667F15FF91@parallels.com>
References: <1304536548-3052-1-git-send-email-vdavydov@parallels.com>
	 <20110506071830.GD23166@elte.hu>
	 <9532E773-BD05-4A18-B9BD-6B667F15FF91@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 11:10:38 +0200
Message-ID: <1305018638.2914.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 14:02 +0400, Vladimir Davydov wrote:
> 
> But looking through the code, I found the definition: 
> 
> /*  * Number of tasks to iterate in a single balance run.  * Limited
> because this is done with IRQs disabled.  */ const_debug unsigned int
> sysctl_sched_nr_migrate = 32; 
> 
> However, AFAIS from the code, the number of tasks to iterate is
> virtually unlimited. So I conclude either the comment is confusing, or
> the logic is wrong. 
> 

Right, so I mostly agree with your (haven't actually read your patch
yet), the one worry I have is that we'll get stuck endlessly trying to
balance the first cgroup and when there's enough tasks in there but not
enough weight, we'll get stuck not making much progress.

This is one of the many things with the whole cgroup mess that needs
proper sorting out.

So yes, I agree with your interpretation of the sysctl, but I don't
think a straight fwd accounting 'fix' will actually result in a better
kernel.



