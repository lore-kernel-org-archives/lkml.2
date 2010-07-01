Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab0GAAHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 20:07:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36667 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab0GAAHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 20:07:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 05/11] oom: /proc/<pid>/oom_score treat kernel thread honestly
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100630140328.GC15644@barrios-desktop>
References: <20100630182922.AA56.A69D9226@jp.fujitsu.com> <20100630140328.GC15644@barrios-desktop>
Message-Id: <20100701085309.DA16.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  1 Jul 2010 09:07:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jun 30, 2010 at 06:30:19PM +0900, KOSAKI Motohiro wrote:
> > If kernel thread are using use_mm(), badness() return positive value.
> > This is not big issue because caller care it correctly. but there is
> > one exception, /proc/<pid>/oom_score call badness() directly and
> > don't care the task is regular process.
> > 
> > another example, /proc/1/oom_score return !0 value. but it's unkillable.
> > This incorrectness makes confusing to admin a bit.
> 
> Hmm. If it is a really problem, Could we solve it in proc_oom_score itself?

probably, no good idea. For maintainance view, all oom related code should
be gathered in oom_kill.c.
If you dislike to add messy into badness(), I hope to make badness_for_oom_score()
or something like instead.



