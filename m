Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab0EMUCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:02:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756473Ab0EMUCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:02:51 -0400
Date: Thu, 13 May 2010 12:59:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 7/11] Uprobes Implementation
In-Reply-To: <20100513194034.GA11207@redhat.com>
Message-ID: <alpine.LFD.2.00.1005131256050.3711@i5.linux-foundation.org>
References: <20100413183537.GA17538@redhat.com> <20100415093506.GA2064@linux.vnet.ibm.com> <20100419193139.GA24080@redhat.com> <20100420124358.GA20675@linux.vnet.ibm.com> <20100420153023.GA9351@redhat.com> <20100421065948.GA5440@linux.vnet.ibm.com>
 <20100421160515.GA11321@redhat.com> <20100422133154.GA10776@linux.vnet.ibm.com> <20100422154059.GA5916@redhat.com> <1273610723.1810.105.camel@laptop> <20100513194034.GA11207@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 May 2010, Oleg Nesterov wrote:
> 
> But I still think this doesn't actually matter, replace_page() shouldn't
> preserve the mapping, it should always install the anonymous page. I can
> be wrong, of course.

Well, if I reasd the patches right, uprobes will use "copy_to_user()" for 
the self-probing case. So that would definitely just modify a shared 
mapping.

Of course, arguably, who really cares? As long as it's not a security 
issue (and it isn't - since the person could just have written to the 
thing directly instead), I guess it doesn't much matter. But it's a bit 
sad when a probing feature either

 - changes a global mapping that may be executed by other non-related 
   processes that the prober isn't even _aware_ of.

 - changes semantics by creating a non-coherent private page

so arguably it would be good to just make the rule be that you cannot 
probe a shared mapping. Because whatever you do, it's always the wrong 
thing.

			Linus
