Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab1JRRZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 13:25:35 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50080 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885Ab1JRRZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 13:25:33 -0400
Date: Tue, 18 Oct 2011 22:17:39 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/X] uprobes: write_opcode() needs put_page(new_page)
 unconditionally
Message-ID: <20111018164739.GI11831@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20111015190007.GA30243@redhat.com>
 <20111015190057.GC30243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111015190057.GC30243@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11101817-8974-0000-0000-000000EEB7A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Every write_opcode()->__replace_page() leaks the new page on success.
> 
> We have the reference after alloc_page_vma(), then __replace_page()
> does another get_page() for the new mapping, we need put_page(new_page)
> in any case.
> 
> Alternatively we could remove __replace_page()->get_page() but it is
> better to change write_opcode(). This way it is simpler to unify the
> code with ksm.c:replace_page() and we can simplify the error handling
> in write_opcode(), the patch simply adds a single page_cache_release()
> under "unlock_out" label.

I have folded this change and your other suggested changes into my patches.

-- 
Thanks and Regards
Srikar

