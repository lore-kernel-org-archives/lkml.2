Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951Ab1DYEVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 00:21:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53773 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1DYEVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 00:21:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 1/2] break out page allocation warning code
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110421103009.731B.A69D9226@jp.fujitsu.com>
References: <1303331695.2796.159.camel@work-vm> <20110421103009.731B.A69D9226@jp.fujitsu.com>
Message-Id: <20110425132333.266E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 25 Apr 2011 13:21:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I'd prefer that we remove /proc/pid/comm entirely or at least prevent 
> > > writing to it unless CONFIG_EXPERT.
> > 
> > Eeeh. That's probably going to be a tough sell, as I think there is
> > wider interest in what it provides. Its useful for debugging
> > applications not kernels, so I doubt folks will want to rebuild their
> > kernel to try to analyze a java issue.
> > 
> > So I'm well aware that there is the chance that you catch the race and
> > read an incomplete/invalid comm (it was discussed at length when the
> > change went in), but somewhere I've missed how that's causing actual
> > problems. Other then just being "evil" and having the documented race,
> > could you clarify what the issue is that your hitting?
> 
> The problem is, there is no documented as well. Okay, I recognized you
> introduced new locking rule for task->comm. But there is no documented
> it. Thus, We have no way to review current callsites are correct or not.
> Can you please do it? And, I have a question. Do you mean now task->comm
> reader don't need task_lock() even if it is another thread?
> 
> _if_ every task->comm reader have to realize it has a chance to read
> incomplete/invalid comm, task_lock() doesn't makes any help.

ping?



