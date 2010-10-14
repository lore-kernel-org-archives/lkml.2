Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab0JNJzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:55:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46937 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab0JNJzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:55:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 14 Oct 2010 18:50:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>,
        Nikhil Rao <ncrao@google.com>
Subject: Re: [PATCH v3 3/7] sched: throttle cfs_rq entities which exceed
 their local quota
Message-Id: <20101014185002.6ecb2bf5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1287047542.29097.169.camel@twins>
References: <20101012074910.GA9893@in.ibm.com>
	<20101012075202.GD9893@in.ibm.com>
	<20101013153421.b38a5c6f.kamezawa.hiroyu@jp.fujitsu.com>
	<1287047542.29097.169.camel@twins>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 11:12:22 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-10-13 at 15:34 +0900, KAMEZAWA Hiroyuki wrote:
> > cpu.share and bandwidth control can't be used simultaneously or...
> > is this fair ? I'm not familiar with scheduler but this allows boost this tg.
> > Could you add a brief documentaion of a spec/feature. in the next post ?
> 
> Like explained, shares control the proportional distribution of time
> between groups, bandwidth puts a limit on how much time a group can
> take. It can cause a group to receive less than its fair share, but
> never more.
> 
> There is, however, a problem with all this, and that is that all this
> explicit idling of tasks can lead to a form of priority inversion.
> Regular preemptive scheduling already suffers from this, but explicitly
> idling tasks exacerbates the situation.
> 
> You basically get to add the longest induced idle time to all your lock
> hold times.
> 

What is the user-visible difference of the problem between
  1) limit share to be very small.
  2) use throttole.

If share is used, lock-hodler's priority is boosted ?

Thanks,
-Kame

