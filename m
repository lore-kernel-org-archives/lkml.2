Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab0CXKXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:23:00 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:56799 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab0CXKW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:22:59 -0400
Date: Wed, 24 Mar 2010 15:52:52 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 7/10] Uprobes Implementation
Message-ID: <20100324102252.GA10710@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
 <20100320142617.11427.23852.sendpatchset@localhost6.localdomain6>
 <1269342115.5279.1620.camel@twins>
 <20100323122335.GB26762@linux.vnet.ibm.com>
 <1269352012.5109.22.camel@twins>
 <4BA8CE39.8050203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4BA8CE39.8050203@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyway, the patch order looks a bit odd, because user_bkpt uses XOL
> but XOL patch is introduced after user_bkpt patch...
> 
user_bkpt provides xol strategy.

user_bkpt_xol patch only provides slot allocation for Execution out of
line strategy.  It doesnt implement execution out of line strategy.
The current implementation assumes that we pass the user_bkpt structure
as an argument while allocating/freeing a slot.

user_bkpt knows how to handle execution out of line. Its working is
independent of how and where the slot is allocated.  The field xol_vaddr
points to a location which holds the copy of the instruction to be
single-stepped/executed.

Hence user_bkpt patch was followed by user_bkpt_xol patch.

--
Thanks and Regards
Srikar

> Thank you,
> 
> -- 
> Masami Hiramatsu
> e-mail: mhiramat@redhat.com
> 
