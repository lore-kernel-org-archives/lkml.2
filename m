Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab0FNOoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:44:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36282 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab0FNOoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:44:06 -0400
Date: Mon, 14 Jun 2010 16:44:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
Message-ID: <20100614144403.GA369@basil.fritz.box>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com> <20100612102558.GA4000@elte.hu> <4C15A5D1.1040104@jp.fujitsu.com> <20100614135403.GH4894@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614135403.GH4894@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the perf event subsytem can log events in NMI context already and
> deliver them to userspace when the NMI is done.  This is why I think Ingo
> wants MCE to be updated to sit on top of the perf event subsytem to avoid
> re-invent everything again.

perf is not solving the problem this is trying to solve.

> Then again I do not know enough about the MCE stuff to understand what you
> mean when an event comes in but you can't handle it in an NMI-safe
> context.  An example would be helpful.

At least for MCE hwpoison recovery needs to sleep and you obviously cannot sleep in
NMI like context. The way it's done is to first do a self interrupt, then do a work queue
wakeup and finally the sleeping operations. 

perf does not fit into this because it has no way to process such an event
inside the kernel.

Anyways this just cleans up the existing mechanism to share some code.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
