Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab1BXPxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 10:53:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:33826 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab1BXPxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 10:53:37 -0500
Subject: Re: [CFS Bandwidth Control v4 3/7] sched: throttle cfs_rq entities
 which exceed their local quota
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
In-Reply-To: <20110224154547.GA3000@in.ibm.com>
References: <20110216031831.571628191@google.com>
	 <20110216031841.068673650@google.com> <1298467933.2217.765.camel@twins>
	 <20110224052101.GA2755@in.ibm.com> <1298545501.2428.18.camel@twins>
	 <20110224154547.GA3000@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Feb 2011 16:52:53 +0100
Message-ID: <1298562773.2428.230.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 21:15 +0530, Bharata B Rao wrote:
> While I admit that our load balancing semantics wrt thorttled entities are
> not consistent (we don't allow pulling of tasks directly from throttled
> cfs_rqs, while allow pulling of tasks from a throttled hierarchy as in the
> above case), I am beginning to think if it works out to be advantageous.
> Is there a chance that the task gets to run on other CPU where the hierarchy
> isn't throttled since runtime is still available ? 

Possible yes, but the load-balancer doesn't know about that, not should
it (its complicated, and broken, enough, no need to add more cruft to
it).

I'm starting to think you all should just toss all this and start over,
its just too smelly.
