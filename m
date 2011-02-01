Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1BAUEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:04:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:43883 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab1BAUEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:04:42 -0500
Subject: Re: [PATCH v2 5/6] KVM-GST: adjust scheduler cpu power
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1296590129.5081.130.camel@mothafucka.localdomain>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	 <1296244340-15173-6-git-send-email-glommer@redhat.com>
	 <1296473120.15234.375.camel@laptop>
	 <1296575996.5081.20.camel@mothafucka.localdomain>
	 <1296577168.26581.240.camel@laptop>
	 <1296577358.5081.23.camel@mothafucka.localdomain>
	 <1296586771.26581.298.camel@laptop>
	 <1296590129.5081.130.camel@mothafucka.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 21:04:57 +0100
Message-ID: <1296590698.26581.303.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 17:55 -0200, Glauber Costa wrote:
> 
> update_rq_clock_task still have to keep track of what was the last steal
> time value we saw, in the same way it does for irq.

Right, the CONFIG_SCHED_PARAVIRT patch I sent earlier adds a
prev_steal_time member to struct rq for this purpose.

>  One option is to
> call update_rq_clock_task from inside kvm-code, but I don't really like
> it very much.

Why would you need to call anything from the kvm code?

Simply make u64 steal_time_clock(int cpu) a paravirt function with u64
native_steal_time_clock(int cpu) { return 0ULL; }. Possibly avoid the
whole CONFIG_SCHED_PARAVIRT block in update_rq_clock_task() for !
paravirt guests.

