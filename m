Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab2DPPfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:35:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab2DPPfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:35:43 -0400
Date: Mon, 16 Apr 2012 17:34:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
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
Subject: Re: [PATCH 2/6] uprobes: introduce is_swbp_at_addr_fast()
Message-ID: <20120416153408.GA8852@redhat.com>
References: <20120405222024.GA19154@redhat.com> <20120405222106.GB19166@redhat.com> <1334570935.28150.25.camel@twins> <20120416144457.GA7018@redhat.com> <1334588109.28150.59.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334588109.28150.59.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, Peter Zijlstra wrote:
>
> Can't we 'optimize' read_opcode() by doing the pagefault_disable() +
> __copy_from_user_inatomic() optimistically before going down the whole
> gup()+lock+kmap path?

Unlikely, the task is not current.

Oleg.

