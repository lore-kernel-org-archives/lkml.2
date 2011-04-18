Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1DRMVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 08:21:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59735 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab1DRMVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 08:21:37 -0400
Subject: Re: [PATCH v3 2.6.39-rc1-tip 6/26]  6: Uprobes:
 register/unregister probes.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110401143338.15455.98645.sendpatchset@localhost6.localdomain6>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
	 <20110401143338.15455.98645.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Apr 2011 14:20:36 +0200
Message-ID: <1303129236.32491.778.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 20:03 +0530, Srikar Dronamraju wrote:
> +static int remove_uprobe(struct mm_struct *mm, struct uprobe *uprobe)
> +{
> +       int ret = 0;
> +
> +       /*TODO: remove breakpoint */
> +       if (!ret)
> +               atomic_dec(&mm->uprobes_count);
> +
> +       return ret;
> +}

> +static void delete_uprobe(struct mm_struct *mm, struct uprobe *uprobe)
> +{
> +       down_read(&mm->mmap_sem);
> +       remove_uprobe(mm, uprobe);
> +       list_del(&mm->uprobes_list);
> +       up_read(&mm->mmap_sem);
> +       mmput(mm);
> +}

> +static void erase_uprobe(struct uprobe *uprobe)
> +{
> +       unsigned long flags;
> +
> +       synchronize_sched();
> +       spin_lock_irqsave(&treelock, flags);
> +       rb_erase(&uprobe->rb_node, &uprobes_tree);
> +       spin_unlock_irqrestore(&treelock, flags);
> +       iput(uprobe->inode);
> +} 

remove,delete,erase.. head spins.. ;-)


