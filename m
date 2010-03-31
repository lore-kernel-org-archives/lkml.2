Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab0CaHEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 03:04:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25911 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab0CaHEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 03:04:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=yNm7YVAWGUaag+KrnL/NoIX0PFwrQJ3qANLh9xqroFIw95lS1nUJ/Ymk7OQmJAR7u
	fUagrmQ3Oj3IcewBBD53g==
Date: Wed, 31 Mar 2010 00:04:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: balbir@linux.vnet.ibm.com, anfei <anfei.zhou@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp, Mel Gorman <mel@csn.ul.ie>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom killer: break from infinite loop
In-Reply-To: <20100331153152.3004e41c.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1003302358500.7072@chino.kir.corp.google.com>
References: <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com> <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329140633.GA26464@desktop> <alpine.DEB.2.00.1003291259400.14859@chino.kir.corp.google.com>
 <20100330142923.GA10099@desktop> <alpine.DEB.2.00.1003301326490.5234@chino.kir.corp.google.com> <20100331095714.9137caab.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1003302302420.22316@chino.kir.corp.google.com> <20100331151356.673c16c0.kamezawa.hiroyu@jp.fujitsu.com>
 <20100331063007.GN3308@balbir.in.ibm.com> <20100331153152.3004e41c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010, KAMEZAWA Hiroyuki wrote:

> "By hand" includes "automatically with daemon program", of course.
> 
> Hmm, in short, your opinion is "killing current is good for now" ?
> 
> I have no strong opinion, here. (Because I'll recommend all customers to
> disable oom kill if they don't want any task to be killed automatically.)
> 

I think there're a couple of options: either define threshold notifiers 
with memory.usage_in_bytes so userspace can proactively address low memory 
situations prior to oom, or use the oom notifier after setting 
echo 1 > /dev/cgroup/blah/memory.oom_control to address those issues 
in userspace as they happen.  If userspace wants to defer back to the 
kernel oom killer because it can't raise max_usage_in_bytes, then
echo 0 > /dev/cgroup/blah/memory.oom_control should take care of it 
instantly and I'd rather see a misconfigured memcg with tasks that are 
OOM_DISABLE but not memcg->oom_kill_disable to be starved of memory than 
panicking the entire system.

Those are good options for users having to deal with low memory 
situations, thanks for continuing to work on it!
