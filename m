Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab1LHXmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 18:42:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53996 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab1LHXmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 18:42:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Dec 2011 08:41:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, rientjes@google.com, dchinner@redhat.com
Subject: Re: [PATCH] oom: add tracepoints for oom_score_adj
Message-Id: <20111209084103.e3fea1f7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4EE0F4EF.4010301@jp.fujitsu.com>
References: <20111207095434.5f2fed4b.kamezawa.hiroyu@jp.fujitsu.com>
	<4EDF99B2.6040007@jp.fujitsu.com>
	<20111208104705.b2e50039.kamezawa.hiroyu@jp.fujitsu.com>
	<4EE0F4EF.4010301@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Dec 2011 12:33:35 -0500
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> On 12/7/2011 8:47 PM, KAMEZAWA Hiroyuki wrote:
> > On Wed, 07 Dec 2011 11:52:02 -0500
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> >> On 12/6/2011 7:54 PM, KAMEZAWA Hiroyuki wrote:
> >>> >From 28189e4622fd97324893a0b234183f64472a54d6 Mon Sep 17 00:00:00 2001
> >>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >>> Date: Wed, 7 Dec 2011 09:58:16 +0900
> >>> Subject: [PATCH] oom: trace point for oom_score_adj
> >>>
> >>> oom_score_adj is set to prevent a task from being killed by OOM-Killer.
> >>> Some daemons sets this value and their children inerit it sometimes.
> >>> Because inheritance of oom_score_adj is done automatically, users
> >>> can be confused at seeing the value and finds it's hard to debug.
> >>>
> >>> This patch adds trace point for oom_score_adj. This adds 3 trace
> >>> points. at
> >>> 	- update oom_score_adj
> >>
> >>
> >>> 	- fork()
> >>> 	- rename task->comm(typically, exec())
> >>
> >> I don't think they have oom specific thing. Can you please add generic fork and
> >> task rename tracepoint instead?
> >>
> > I think it makes oom-targeted debug difficult.
> > This tracehook using task->signal->oom_score_adj as filter.
> > This reduces traces much and makes debugging easier.
> >  
> > If you need another trace point for other purpose, another trace point
> > should be better. For generic purpose, oom_socre_adj filtering will not
> > be necessary.
> 
> see Documentation/trace/event.txt 5. Event filgtering
> 
> Now, both ftrace and perf have good filter feature. Isn't this enough?
> 

Could you make patch ? Then, I stop this and go other probelm.

Thanks,
-Kame

