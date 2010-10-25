Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab0JYASk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 20:18:40 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59982 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab0JYASj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 20:18:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 25 Oct 2010 09:13:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: steve@digidescorp.com
Cc: linux-mm@kvack.org, balbir@linux.vnet.ibm.com, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] nommu: add anonymous page memcg accounting
Message-Id: <20101025091304.871c8a50.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1287753968.2589.58.camel@iscandar.digidescorp.com>
References: <1287664088-4483-1-git-send-email-steve@digidescorp.com>
	<20101022122010.793bebac.kamezawa.hiroyu@jp.fujitsu.com>
	<1287753968.2589.58.camel@iscandar.digidescorp.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 08:26:08 -0500
"Steven J. Magnani" <steve@digidescorp.com> wrote:

> On Fri, 2010-10-22 at 12:20 +0900, KAMEZAWA Hiroyuki wrote:
> > BTW, have you tried oom_notifier+NOMMU memory limit oom-killer ?
> > It may be a chance to implement a custom OOM-Killer in userland on
> > EMBEDED systems.
> 
> No - for what I need (simple sandboxing) just running my 'problem'
> process in a memory cgroup is sufficient. I might even be able to get
> away with oom_kill_allocating_task and no cgroup, but since that would
> allow dosfsck to run the system completely out of memory there's no
> guarantee that it would be the one that pushes the system over the edge.
> 
> What do you mean by "NOMMU memory limit"? (Is there some other way to
> achieve the same functionality?)
> 

I just meant memory cgroup for NOMMU.

> I looked into David's initial suggestion of using ulimit to create a
> sandbox but it seems that nommu.c doesn't respect RLIMIT_AS. When I can
> find some time I'll try to cook up a patch for that.

Hmm. I think fixing RLIMIT_AS is better. (but no nack to this patch.)
Using memcg for _a_ program sounds like overkill...

Thanks,
-Kame

