Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab1AZPQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:16:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55785 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab1AZPQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:16:40 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 8/20]  8: uprobes: mmap and fork
 hooks.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20110126145955.GJ19725@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
	 <1295957739.28776.717.camel@laptop>
	 <20110126090346.GH19725@linux.vnet.ibm.com>
	 <1296037239.28776.1149.camel@laptop>
	 <20110126145955.GJ19725@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Jan 2011 16:16:49 +0100
Message-ID: <1296055009.28776.1202.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 20:29 +0530, Srikar Dronamraju wrote:
> list_for_each_entry_safe(mm, tmpmm, &tmp_list, uprobes_list) {
>                 down_read(&mm->map_sem);
>                 if (!install_uprobe(mm, uprobe))
>                         ret = 0;
>                 up_read(&mm->map_sem);
>                 list_del(&mm->uprobes_list);
>                 mmput(mm);
> } 

and the tmp_list thing works because new mm's will hit the mmap callback
and you cannot loose mm's due to the refcount, right?


