Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0JNKA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 06:00:29 -0400
Received: from canuck.infradead.org ([134.117.69.58]:53208 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab0JNKA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 06:00:28 -0400
Subject: Re: [PATCH v3 3/7] sched: throttle cfs_rq entities which exceed
 their local quota
From: Peter Zijlstra <peterz@infradead.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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
In-Reply-To: <20101014185002.6ecb2bf5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101012074910.GA9893@in.ibm.com>
	 <20101012075202.GD9893@in.ibm.com>
	 <20101013153421.b38a5c6f.kamezawa.hiroyu@jp.fujitsu.com>
	 <1287047542.29097.169.camel@twins>
	 <20101014185002.6ecb2bf5.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Oct 2010 11:59:55 +0200
Message-ID: <1287050395.29097.176.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 18:50 +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 14 Oct 2010 11:12:22 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2010-10-13 at 15:34 +0900, KAMEZAWA Hiroyuki wrote:
> > > cpu.share and bandwidth control can't be used simultaneously or...
> > > is this fair ? I'm not familiar with scheduler but this allows boost this tg.
> > > Could you add a brief documentaion of a spec/feature. in the next post ?
> > 
> > Like explained, shares control the proportional distribution of time
> > between groups, bandwidth puts a limit on how much time a group can
> > take. It can cause a group to receive less than its fair share, but
> > never more.
> > 
> > There is, however, a problem with all this, and that is that all this
> > explicit idling of tasks can lead to a form of priority inversion.
> > Regular preemptive scheduling already suffers from this, but explicitly
> > idling tasks exacerbates the situation.
> > 
> > You basically get to add the longest induced idle time to all your lock
> > hold times.
> > 
> 
> What is the user-visible difference of the problem between
>   1) limit share to be very small.
>   2) use throttole.
> 
> If share is used, lock-hodler's priority is boosted ?

No, both lead to the same problem, its just that this adds another
dimension to it.. and I'm fairly sure people won't realise this until it
bites them in the ass.


