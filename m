Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab1EGQa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 12:30:59 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39325 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab1EGQa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 12:30:58 -0400
Date: Sat, 7 May 2011 12:30:50 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: John Stultz <john.stultz@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] comm: ext4: Protect task->comm access by using
 get_task_comm()
Message-ID: <20110507163050.GA6046@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	John Stultz <john.stultz@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	LKML <linux-kernel@vger.kernel.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org
References: <1303963411-2064-1-git-send-email-john.stultz@linaro.org>
 <1303963411-2064-4-git-send-email-john.stultz@linaro.org>
 <alpine.DEB.2.00.1104281426210.21665@chino.kir.corp.google.com>
 <20110504163657.52dca3fc.akpm@linux-foundation.org>
 <1304553310.2943.18.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304553310.2943.18.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 04:55:10PM -0700, John Stultz wrote:
> > I'm suspecting that approximately 100% of the get_task_comm() callsites
> > are using it for a printk, so how about we add a %p thingy for it then
> > zap lots of code?
> 
> DaveH suggested the same, actually. And that would work with the
> seqlocking pretty easily to avoid DavidR's issue.

+1 for a %p thingy for printk's; although the other potential use case
that we should think about is for tracepoints.  Getting something that
works for ftrace as well as perf would be a really good thing.

I suspect what we would want to do though (since people have been
trying very hard to keep the trace records as small as possible, so we
can include as much as possible) is to only record the pid, and have a
tracepoint which reports when process's comm value has been set to a
new value.  So any objections to adding a tracepoint in
set_task_comm()?

And would you like me to send the patch, or do you want to do it since
you're putting a patch series together anyway?

    	      	      	      	  	    - Ted

