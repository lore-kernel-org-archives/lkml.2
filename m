Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab2ADQuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 11:50:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:42033 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab2ADQui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 11:50:38 -0500
Message-ID: <1325695788.2697.3.camel@twins>
Subject: Re: [PATCH v8 3.2.0-rc5 1/9] uprobes: Install and remove
 breakpoints.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 04 Jan 2012 17:49:48 +0100
In-Reply-To: <20111216122808.2085.76986.sendpatchset@srdronam.in.ibm.com>
References: <20111216122756.2085.95791.sendpatchset@srdronam.in.ibm.com>
	 <20111216122808.2085.76986.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 17:58 +0530, Srikar Dronamraju wrote:
> +static void __unregister_uprobe(struct uprobe *uprobe)
> +{
> +       if (!register_for_each_vma(uprobe, false))
> +               delete_uprobe(uprobe);
> +
> +       /* TODO : cant unregister? schedule a worker thread */
> +} 

I was about to suggest we merge it, but we really can't with a hole that
size..
