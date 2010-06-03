Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab0FCUcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:32:16 -0400
Received: from smtp-out.google.com ([74.125.121.35]:27139 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab0FCUcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:32:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=uCV7uCOF5ZhovC1hP+pTUExtO8Y8IwY7bu6+2AmybiPQqPgt8O6mmcEvZLjCv9QZ8
	3bvpvBwRFHnA/pNrnQXVw==
Date: Thu, 3 Jun 2010 13:32:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, balbir@linux.vnet.ibm.com,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Mel Gorman <mel@csn.ul.ie>, williams@redhat.com
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
In-Reply-To: <1275551449.27810.34905.camel@twins>
Message-ID: <alpine.DEB.2.00.1006031327480.10856@chino.kir.corp.google.com>
References: <20100601173535.GD23428@uudg.org> <alpine.DEB.2.00.1006011347060.13136@chino.kir.corp.google.com> <20100602220429.F51E.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006021410300.32666@chino.kir.corp.google.com> <1275551449.27810.34905.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010, Peter Zijlstra wrote:

> > And that can reduce the runtime of the thread holding a writelock on 
> > mm->mmap_sem, making the exit actually take longer than without the patch 
> > if its priority is significantly higher, especially on smaller machines. 
> 
> /me smells an inversion... on -rt we solved those ;-)
> 

Right, but I don't see how increasing an oom killed tasks priority to a 
divine priority doesn't impact the priorities of other tasks which may be 
blocking the exit of that task, namely a coredumper or holder of 
mm->mmap_sem.  This patch also doesn't address how it negatively impacts 
the priorities of jobs running in different cpusets (although sharing the 
same cpus) because one cpuset is oom.
