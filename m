Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab1CCCCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:02:05 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43914 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab1CCCCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:02:02 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 4/5] mm: Add hit/miss accounting for Page Cache
Cc: kosaki.motohiro@jp.fujitsu.com, Liu Yuan <namei.unix@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jaxboe@fusionio.com,
        akpm@linux-foundation.org, fengguang.wu@intel.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?ISO-2022-JP?B?RnIbJEJxRXFTGyhCaWM=?= Weisbecker 
	<fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20110302084542.GA20795@elte.hu>
References: <1299055090-23976-4-git-send-email-namei.unix@gmail.com> <20110302084542.GA20795@elte.hu>
Message-Id: <20110303103337.B93C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Mar 2011 11:01:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * Liu Yuan <namei.unix@gmail.com> wrote:
> 
> > +		if (likely(!retry_find) && page && PageUptodate(page))
> > +			page_cache_acct_hit(inode->i_sb, READ);
> > +		else
> > +			page_cache_acct_missed(inode->i_sb, READ);
> 
> Sigh.
> 
> This would make such a nice tracepoint or sw perf event. It could be collected in a 
> 'count' form, equivalent to the stats you are aiming for here, or it could even be 
> traced, if someone is interested in such details.
> 
> It could be mixed with other events, enriching multiple apps at once.

Totally agreed.


> But, instead of trying to improve those aspects of our existing instrumentation 
> frameworks, mm/* is gradually growing its own special instrumentation hacks, missing 
> the big picture and fragmenting the instrumentation space some more.
> 
> That trend is somewhat sad.

So, I think thing is, the stat is how much people and how frequently used.
If it is really really really common, /proc/meminfo or similar special place
is good idea. Another example, If the stat can help our MM debugging to
handle LKML bug report, it is worth to have special care. But other almost
else case are better to use generic framework.


