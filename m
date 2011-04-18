Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab1DRQWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:22:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37278 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab1DRQWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:22:46 -0400
Subject: Re: [PATCH v3 2.6.39-rc1-tip 9/26]  9: uprobes: mmap and fork
 hooks.
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
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110401143413.15455.75831.sendpatchset@localhost6.localdomain6>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
	 <20110401143413.15455.75831.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Apr 2011 18:21:57 +0200
Message-ID: <1303143717.32491.872.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 20:04 +0530, Srikar Dronamraju wrote:
> +       if (vma) {
> +               /*
> +                * We get here from uprobe_mmap() -- the case where we
> +                * are trying to copy an instruction from a page that's
> +                * not yet in page cache.
> +                *
> +                * Read page in before copy.
> +                */
> +               struct file *filp = vma->vm_file;
> +
> +               if (!filp)
> +                       return -EINVAL;
> +               page_cache_sync_readahead(mapping, &filp->f_ra, filp, idx, 1);
> +       }
> +       page = grab_cache_page(mapping, idx); 

So I don't see why that isn't so for the normal install_uprobe() <-
register_uprobe() path.
