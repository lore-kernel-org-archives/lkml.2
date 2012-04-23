Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2DWV0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:26:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511Ab2DWV0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:26:45 -0400
Date: Mon, 23 Apr 2012 23:25:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: Re: [RFC 0/6] uprobes: kill uprobes_srcu/uprobe_srcu_id
Message-ID: <20120423212536.GA8700@redhat.com>
References: <1334571419.28150.30.camel@twins> <20120416214707.GA27639@redhat.com> <1334916861.2463.50.camel@laptop> <20120420183718.GA2236@redhat.com> <1335165240.28150.89.camel@twins> <20120423072445.GC8357@linux.vnet.ibm.com> <1335166842.28150.92.camel@twins> <20120423172957.GA29708@redhat.com> <1335208690.2463.84.camel@laptop> <20120423205049.GA7831@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423205049.GA7831@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to mention,

On 04/23, Oleg Nesterov wrote:
>
> Just it seems to me there are to many "details"
> we should discuss to make the filtering reasonable.

And so far we assumed that consumer->filter() is "stable" and never
changes its mind.

Perhaps this is fine, but I am not sure. May we need need some
interface to add/del the task. Probably not, but unregister + register
doesn't look very convenient and can miss a hit.

> Yes, and probably this makes sense for handler_chain(). Although otoh
> I do not really understand what this filter buys us at this point.

But if we change the rules so that ->filter() or ->handler() itself can
return the "please remove this bp from ->mm" then perhaps it makes more
sense for the filtering. Again, not sure.

Oleg.

