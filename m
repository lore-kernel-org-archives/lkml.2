Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab1IZQvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 12:51:15 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36177 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab1IZQvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 12:51:13 -0400
Date: Mon, 26 Sep 2011 22:04:26 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 17/26]   x86: arch specific hooks for
 pre/post singlestep handling.
Message-ID: <20110926163426.GA15435@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120325.25326.11641.sendpatchset@srdronam.in.ibm.com>
 <1317047033.1763.27.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1317047033.1763.27.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11092616-2398-0000-0000-0000007FB5E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-09-26 16:23:53]:

> On Tue, 2011-09-20 at 17:33 +0530, Srikar Dronamraju wrote:
> > +fail:
> > +       pr_warn_once("uprobes: Failed to adjust return address after"
> > +               " single-stepping call instruction;"
> > +               " pid=%d, sp=%#lx\n", current->pid, sp);
> > +       return -EFAULT; 
> 
> So how can that happen? Single-Step while someone unmapped the stack?

We do a copy_to_user, copy_from_user just above this, Now if either of
them fail, we have no choice but to Bail out. What caused this EFault
may not be under Uprobes's Control.

-- 
Thanks and Regards
Srikar

