Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab1JFHKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 03:10:55 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47937 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab1JFHKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 03:10:53 -0400
Date: Thu, 6 Oct 2011 12:23:26 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 9/26]   Uprobes: Background page
 replacement.
Message-ID: <20111006065326.GD17591@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120137.25326.72005.sendpatchset@srdronam.in.ibm.com>
 <20111005161914.GA903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111005161914.GA903@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2011-10-05 18:19:14]:

> On 09/20, Srikar Dronamraju wrote:
> >
> > +int __weak read_opcode(struct task_struct *tsk, unsigned long vaddr,
> > +						uprobe_opcode_t *opcode)
> > +{
> > +	struct vm_area_struct *vma;
> > +	struct page *page;
> > +	void *vaddr_new;
> > +	int ret;
> > +
> > +	ret = get_user_pages(tsk, tsk->mm, vaddr, 1, 0, 0, &page, &vma);
> > +	if (ret <= 0)
> > +		return ret;
> > +	ret = -EINVAL;
> > +
> > +	/*
> > +	 * We are interested in text pages only. Our pages of interest
> > +	 * should be mapped for read and execute only. We desist from
> > +	 * adding probes in write mapped pages since the breakpoints
> > +	 * might end up in the file copy.
> > +	 */
> > +	if (!valid_vma(vma))
> > +		goto put_out;
> 
> Another case when valid_vma() looks suspicious. We are going to restore
> the original instruction. We shouldn't fail (at least we shouldn't "leak"
> ->mm_uprobes_count) if ->vm_flags was changed between register_uprobe()
> and unregister_uprobe().
> 

Agree.

-- 
Thanks and Regards
Srikar
