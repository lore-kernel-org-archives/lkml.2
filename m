Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab0K3NDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 08:03:47 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39066 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0K3NDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 08:03:46 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [resend][PATCH 2/4] Revert "oom: deprecate oom_adj tunable"
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1011271737110.3764@chino.kir.corp.google.com>
References: <20101123160259.7B9C.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011271737110.3764@chino.kir.corp.google.com>
Message-Id: <20101130220221.832B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 30 Nov 2010 22:03:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 23 Nov 2010, KOSAKI Motohiro wrote:
> 
> > > > No irrelevant. Your patch break their environment even though
> > > > they don't use oom_adj explicitly. because their application are using it.
> > > > 
> > > 
> > > The _only_ difference too oom_adj since the rewrite is that it is now 
> > > mapped on a linear scale rather than an exponential scale.  
> > 
> > _only_ mean don't ZERO different. Why do userland application need to rewrite?
> > 
> 
> Because NOTHING breaks with the new mapping.  Eight months later since 
> this was initially proposed on linux-mm, you still cannot show a single 
> example that depended on the exponential mapping of oom_adj.  I'm not 
> going to continue responding to your criticism about this point since your 
> argument is completely and utterly baseless.

No regression mean no break. Not single nor multiple. see?


> 
> > Again, IF you need to [0 .. 1000] range, you can calculate it by your
> > application. current oom score can be get from /proc/pid/oom_score and
> > total memory can be get from /proc/meminfo. You shouldn't have break
> > anything.
> > 
> 
> That would require the userspace tunable to be adjusted anytime a task's 
> mempolicy changes, its nodemask changes, it's cpuset attachment changes, 

All situation can be calculated on userland. User process can be know
their bindings.



> its mems change, a memcg limit changes, etc.  The only constant is the 
> task's priority, and the current oom_score_adj implementation preserves 
> that unless explicitly changed later by the user.  I completely understand 
> that you may not have a use for this.



