Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab1CNQAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 12:00:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63419 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab1CNQAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 12:00:36 -0400
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=wrudYcXMAyUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=2Mbc6gtD2wY--RsE-9oA:9 a=3CHK3SfEMoD2beyyOoWHghwGNe0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2 2.6.38-rc8-tip 5/20]  5: Uprobes:
 register/unregister probes.
From: Steven Rostedt <rostedt@goodmis.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20110314133454.27435.81020.sendpatchset@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
	 <20110314133454.27435.81020.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Mar 2011 12:00:33 -0400
Message-ID: <1300118433.9910.118.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 19:04 +0530, Srikar Dronamraju wrote:
> +/* Returns 0 if it can install one probe */
> +int register_uprobe(struct inode *inode, loff_t offset,
> +                               struct uprobe_consumer *consumer)
> +{
> +       struct prio_tree_iter iter;
> +       struct list_head tmp_list;
> +       struct address_space *mapping;
> +       struct mm_struct *mm, *tmpmm;
> +       struct vm_area_struct *vma;
> +       struct uprobe *uprobe;
> +       int ret = -1;
> +
> +       if (!inode || !consumer || consumer->next)
> +               return -EINVAL;
> +       uprobe = uprobes_add(inode, offset);

What happens if uprobes_add() returns NULL?

-- Steve

> +       INIT_LIST_HEAD(&tmp_list);
> +
> +       mapping = inode->i_mapping;
> +
> +       mutex_lock(&uprobes_mutex);
> +       if (uprobe->consumers) {
> +               ret = 0;
> +               goto consumers_add;
> +       } 

