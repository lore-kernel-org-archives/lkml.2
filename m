Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0JVN0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:26:14 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:40543 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab0JVN0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:26:13 -0400
X-Spam-Processed: digidescorp.com, Fri, 22 Oct 2010 08:26:12 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=19113766f3=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] nommu: add anonymous page memcg accounting
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, balbir@linux.vnet.ibm.com, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101022122010.793bebac.kamezawa.hiroyu@jp.fujitsu.com>
References: <1287664088-4483-1-git-send-email-steve@digidescorp.com>
	 <20101022122010.793bebac.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Digital Design Corporation
Date: Fri, 22 Oct 2010 08:26:08 -0500
Message-ID: <1287753968.2589.58.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 12:20 +0900, KAMEZAWA Hiroyuki wrote:
> BTW, have you tried oom_notifier+NOMMU memory limit oom-killer ?
> It may be a chance to implement a custom OOM-Killer in userland on
> EMBEDED systems.

No - for what I need (simple sandboxing) just running my 'problem'
process in a memory cgroup is sufficient. I might even be able to get
away with oom_kill_allocating_task and no cgroup, but since that would
allow dosfsck to run the system completely out of memory there's no
guarantee that it would be the one that pushes the system over the edge.

What do you mean by "NOMMU memory limit"? (Is there some other way to
achieve the same functionality?)

I looked into David's initial suggestion of using ulimit to create a
sandbox but it seems that nommu.c doesn't respect RLIMIT_AS. When I can
find some time I'll try to cook up a patch for that.

Also it seems that nommu.c doesn't ever decrement mm->total_vm, which if
I'm reading the code correctly (before the 2.6.36 OOM-killer rewrite)
could throw off badness calculations for processes that do lots of
malloc/free operations. In 2.6.36 it doesn't look to me like this would
have any ill effects.

Thanks for all the feedback. I fully agree that maintenance should be a
strong consideration when merging new code.

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>


