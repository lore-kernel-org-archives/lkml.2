Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab2K1Nxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:53:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175Ab2K1Nxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:53:53 -0500
Date: Wed, 28 Nov 2012 15:53:45 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, avi@redhat.com
Subject: Re: [RFC PATCH v2] Add rcu user eqs exception hooks for async page
 fault
Message-ID: <20121128135345.GG928@redhat.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
 <CAFTL4hx0fc_Jo8wkuRZedW4DVEeQceiHMrWVqTqB5k065Wsg8Q@mail.gmail.com>
 <1354090704.3054.13.camel@ThinkPad-T5421.cn.ibm.com>
 <CAFTL4hxPSp1fs4=2g0yFs0d5nFisfUsfDAA9bHWcu+-+tO_ySw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hxPSp1fs4=2g0yFs0d5nFisfUsfDAA9bHWcu+-+tO_ySw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 01:55:42PM +0100, Frederic Weisbecker wrote:
> > So I still want to remove it. And later if it shows that we really needs
> > rcu somewhere in this code path, maybe we could use RCU_NONIDLE() to
> > protect it. ( The suspicious RCU usage reported in commit
> > c5e015d4949aa665 seems related to schedule(), which is not in the code
> > path if we are in cpu idle eqs )
> 
> Yes but if rcu_irq_*() calls are fine to be called there, and I
> believe they are because exception_enter() exits the user mode, we
> should start to protect there right now instead of waiting for a
> potential future warning of illegal RCU use.
> 
Async page not present is not much different from regular page fault
exception when it happens not on idle task (regular #PF cannot happen
on idle task), but code have a special handling for idle task. So why
do you think rcu_irq_*() is required here, but not in page fault
handler?

> >
> > I think we still need Gleb's patch about the idle check in
> > kvm_async_pf_task_wait(), and maybe another patch for the
> > exit_idle()/enter_idle() issue.
> 
> Right.
> 
Done.

--
			Gleb.
