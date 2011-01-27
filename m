Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab1A0Kkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:40:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:57920 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab1A0Kks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:40:48 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 5/20]  5: Uprobes:
 register/unregister probes.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
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
In-Reply-To: <20110127102527.GT19725@linux.vnet.ibm.com>
References: <20101216095817.23751.76989.sendpatchset@localhost6.localdomain6>
	 <1295957744.28776.722.camel@laptop>
	 <20110126075558.GB19725@linux.vnet.ibm.com>
	 <1296036708.28776.1138.camel@laptop>
	 <20110126153036.GN19725@linux.vnet.ibm.com>
	 <1296056756.28776.1247.camel@laptop>
	 <20110126165645.GP19725@linux.vnet.ibm.com>
	 <1296061949.28776.1343.camel@laptop>
	 <20110127100157.GS19725@linux.vnet.ibm.com>
	 <1296123817.15234.57.camel@laptop>
	 <20110127102527.GT19725@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 11:41:17 +0100
Message-ID: <1296124877.15234.76.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 15:55 +0530, Srikar Dronamraju wrote:
> 
> 
> If its not at the exact same location, then our third validation of
> checking that (vaddr == vma->vm_start + uprobe->offset)  should fail
> right?
> 
> Also should it be (vaddr == uprobe->offset + vma->vm_start -
> vma->pgoff << PAGE_SHIFT) ?

Yeah, although I just realized that ->offset should be a u64, since
pgoff is a unsigned long, we can have files up to 44 bit (assuming the
page-size is 12bits).

But yes, this matches the validation I mentioned.
