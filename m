Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1AZP3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:29:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1AZP3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:29:19 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 14/20] 14: uprobes: Handing int3
 and singlestep exception.
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
In-Reply-To: <20110126151418.GL19725@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095957.23751.57040.sendpatchset@localhost6.localdomain6>
	 <1295963779.28776.1059.camel@laptop>
	 <20110126085203.GG19725@linux.vnet.ibm.com>
	 <1296037031.28776.1146.camel@laptop>
	 <20110126151418.GL19725@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Jan 2011 16:29:48 +0100
Message-ID: <1296055788.28776.1222.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 20:44 +0530, Srikar Dronamraju wrote:
> So it simplifies to 
> 
>         down_read(&mm->mmap_sem);
>         vma = find_vma(mm, probept);
>         if (valid_vma(vma)) {
>                u = find_uprobe(vma->vm_file->f_mapping->host,
>                                probept - vma->vm_start);
>         }
>         up_read(&mm->mmap_sem); 

Almost, the offset within a file is something like:

  (address - vma->vm_start) + (vma->vm_pgoff << PAGE_SHIFT)


