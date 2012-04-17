Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab2DQTyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:54:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:54813 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2DQTyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:54:08 -0400
Message-ID: <1334692418.28150.88.camel@twins>
Subject: Re: [PATCH 2/6] uprobes: introduce is_swbp_at_addr_fast()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
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
Date: Tue, 17 Apr 2012 21:53:38 +0200
In-Reply-To: <20120417170958.GA16511@redhat.com>
References: <20120405222024.GA19154@redhat.com>
	 <20120405222106.GB19166@redhat.com> <1334570935.28150.25.camel@twins>
	 <20120416144457.GA7018@redhat.com> <1334588109.28150.59.camel@twins>
	 <20120416153408.GA8852@redhat.com> <1334657287.28150.77.camel@twins>
	 <20120417170958.GA16511@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-17 at 19:09 +0200, Oleg Nesterov wrote:
> 
> This reminds me. Why read_opcode() does lock_page? I was going
> to send the cleanup which removes it, but I need to recheck.
> 
> Perhaps you can explain the reason? 

I can't seem to recall, I suspect its to serialize against
__replace_page(). I can't say if that's strictly needed though.
