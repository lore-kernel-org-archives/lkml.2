Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1GROc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 10:32:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:39961 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1GROcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 10:32:25 -0400
Subject: Re: [PATCH v4 3.0-rc2-tip 7/22]  7: uprobes: mmap and fork hooks.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110718092055.GA1210@linux.vnet.ibm.com>
References: <20110617045000.GM4952@linux.vnet.ibm.com>
	 <1308297836.13240.380.camel@twins>
	 <20110617090504.GN4952@linux.vnet.ibm.com> <1308303665.2355.11.camel@twins>
	 <1308662243.26237.144.camel@twins>
	 <20110622143906.GF16471@linux.vnet.ibm.com>
	 <20110624020659.GA24776@linux.vnet.ibm.com>
	 <1308901324.27849.7.camel@twins>
	 <20110627064502.GB24776@linux.vnet.ibm.com> <1309165071.6701.4.camel@twins>
	 <20110718092055.GA1210@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Jul 2011 16:31:16 +0200
Message-ID: <1310999476.13765.107.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 14:50 +0530, Srikar Dronamraju wrote:
>  *  - Introduce uprobes_list and uprobes_vaddr in vm_area_struct.
>  *    uprobes_list is a node in the temp list of vmas while
>  *    registering/unregistering uprobes. uprobes_vaddr caches the vaddr to
>  *    insert/remove the breakpoint.
>  *
>  *  - Introduce srcu to synchronize vma deletion with walking the list of
>  *    vma in register/unregister_uprobe.

I don't think you can sell this, that'll make munmap() horridly slow.

>  *  - Introduce uprobes_mmap_mutex to synchronize uprobe deletion and
>  *    mmap_uprobe(). 

Yes, that'll work I think.
