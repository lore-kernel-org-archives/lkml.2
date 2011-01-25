Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab1AYN4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:56:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:46097 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab1AYN4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:56:14 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 11/20] 11: uprobes: slot
 allocation for uprobes
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20101216095926.23751.9405.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095926.23751.9405.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 14:56:16 +0100
Message-ID: <1295963776.28776.1057.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 15:29 +0530, Srikar Dronamraju wrote:
> +       /*
> +        * We keep the vma's vm_start rather than a pointer to the vma
> +        * itself.  The probed process or a naughty kernel module could make
> +        * the vma go away, and we must handle that reasonably gracefully.
> +        */
> +       unsigned long vaddr;            /* Page(s) of instruction slots */ 

You could simply refuse to let the user unmap that area and rogue kernel
modules aren't something you can do anything about anyway.

But yeah..
