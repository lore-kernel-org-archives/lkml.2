Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab0JORZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:25:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:49995 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab0JORZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:25:18 -0400
Subject: Re: [PATCH 3/4] sched: drop group_capacity to 1 only if local
 group has extra capacity
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Venkatesh Pallipadi <venki@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1287162786.2622.16.camel@sbsiddha-MOBL3>
References: <1286996978-7007-4-git-send-email-ncrao@google.com>
	 <1287035281-25579-1-git-send-email-ncrao@google.com>
	 <1287143423.29097.1460.camel@twins>
	 <AANLkTinotiJqfvr9D2yTkuaLDKPcaUaG1dU1goRK8Bi+@mail.gmail.com>
	 <1287162325.1998.101.camel@laptop>
	 <1287162786.2622.16.camel@sbsiddha-MOBL3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 19:24:50 +0200
Message-ID: <1287163490.1998.106.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 10:13 -0700, Suresh Siddha wrote:
> On Fri, 2010-10-15 at 10:05 -0700, Peter Zijlstra wrote:
> > For regular balancing local_group will be the first, since we only
> > ascend the domain tree on the local groups. But its not true for no_hz
> > balancing afaikt.
> 
> Even for NOHZ, we always ascend each cpu's sched domain and the local
> group is the first one always. But yes, we are depending on the local
> group being the first group.

Ah, yes, we take the balance_cpu's domain tree, not the local cpu's
domain tee.

Hrm,.. ok feels slightly tricky though.
