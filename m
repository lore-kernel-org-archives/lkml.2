Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab0EOBHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 21:07:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53006 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0EOBHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 21:07:01 -0400
X-Authority-Analysis: v=1.1 cv=MoOeBCR3UCSroT7bBzr0mtJUqJhHyBWzyNa37ex1qNU= c=1 sm=0 a=NQpeRPGH1YwA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=ibsV2mwkFbXULv0D5a8A:9 a=9agLyGMvdERFPIYEmWctjRbqlw8A:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 12/13 v3] ring-buffer: Add cached pages when freeing
 reader page
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20100514222647.GB14234@Krystal>
References: <20100514192246.079025623@goodmis.org>
	 <20100514192916.945900385@goodmis.org>  <20100514222647.GB14234@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 14 May 2010 21:06:58 -0400
Message-ID: <1273885618.27703.3168.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Peter Zijlsta since he had an interest in this topic ]

On Fri, 2010-05-14 at 18:26 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:

> Trying to understand the effect of splice() putting the page in the page
> cache and how it affects this patch.
> 
> Basically, how do you know you can call free_page() from splice() in the
> first place ? Answering this question will probably help us see if this
> page reuse is OK.

Actually, looking at the code, I'm not sure this is safe. I was thinking
that free_page() would always free the page. But I forgot that pages
have a ref count. And a get_page() will prevent a page from freeing.

So I need to revert this patch, or rather, make a core-5 that removes
this patch and fixes the spelling in the comment.

I can later add something that checks the page ref count, but that can
wait till .36.

-- Steve




