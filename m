Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab0IPGgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:36:32 -0400
Received: from smtp-out.google.com ([74.125.121.35]:20670 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab0IPGg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:36:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=YR/OmuuDQVkS5k6p8q+7vBBPXVodMtM3seV9l6QG38tSNc6u6XZIII+1Sx+D/yCMR
	3am9s3SKVRZf4QFjx1zcg==
Date: Wed, 15 Sep 2010 23:36:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-fsdevel@vger.kernel.org, pageexec@freemail.hu,
        Brad Spengler <spender@grsecurity.net>, Eugene Teo <eugene@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 1/4] oom: remove totalpage normalization from
 oom_badness()
In-Reply-To: <20100916145452.3BB1.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1009152300380.25200@chino.kir.corp.google.com>
References: <20100916144930.3BAE.A69D9226@jp.fujitsu.com> <20100916145452.3BB1.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010, KOSAKI Motohiro wrote:

> Current oom_score_adj is completely broken because It is strongly bound
> google usecase and ignore other all.
> 

We've talked about this issue three times already.  The last two times 
you've sent a revert patch, you failed to followup on the threads:

	http://marc.info/?t=128272938200002
	http://marc.info/?t=128324705200002

And now you've gone above Andrew, who is the maintainer of this code, and 
straight to Linus.  Between that and your failure to respond to my answers 
to your questions, I'm really stunned at how unprofessional you've handled 
this.

I've responded to every one of your emails and I've described the power of 
oom_score_adj as it acts on a higher resolution than oom_adj (1/1000th of 
RAM), respects the dynamic nature of cgroups, provides a rough 
approximation to users of oom_adj, and an exact equivalent of polarizing 
users of oom_adj, which is by far the most common usecase.

That feature, as is the entire oom killer rewrite, is not specific in any 
way to Google, which I've stated many times, yet you constantly insist 
that it's so.  Yes, we deal with oom issues on scales you've never seen.  
And instead of carrying internal patches to fix it since oom_adj is _only_ 
useful for polarizing a task and not relative to others competing for the 
same resources, I reworked the entire heuristic from scratch since we're 
not the only ones who want a sane priority killing.

We are not the only ones who add mems to cpusets, adjust memcg limits, add 
nodes to mempolicies, or use memory hotplug.  oom_adj would require a new 
value whenever you did any of those for a static priority.  The fact that 
you constantly ignore is that the amount of memory that an aggregate of 
tasks can access is _dynamic_ and so the kill priority will change unless 
we define it as a static value that has a unit as a proportion of 
available memory as oom_score_adj does.  Nobody cares about static oom 
scores like you introduce here with the revert; static oom scores mean 
_nothing_ because they are only useful in comparison to other eligible 
tasks.

You never respond to any of this, but you just keep pushing your same old 
revert.  You never responded to my email to Andrew that showed how this 
isn't a regression, so I guess I can only ask Linus to read the same 
email since you're pushing it to him now 
(http://marc.info/?l=linux-mm&m=128393429131399).

I really hope we can put this to rest because it's frankly getting old 
competing with a broken record.
