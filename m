Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab2JVU4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:56:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab2JVU4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:56:01 -0400
Date: Mon, 22 Oct 2012 13:55:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, bhutchings@solarflare.com,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.7 v3] mm, mempolicy: hold task->mempolicy refcount
 while reading numa_maps.
Message-Id: <20121022135559.1ccb14bc.akpm@linux-foundation.org>
In-Reply-To: <5084B3C3.3070906@jp.fujitsu.com>
References: <alpine.DEB.2.00.1210152306320.9480@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1210161657220.14014@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1210161714110.17278@chino.kir.corp.google.com>
	<20121017040515.GA13505@redhat.com>
	<alpine.DEB.2.00.1210162222100.26279@chino.kir.corp.google.com>
	<20121017181413.GA16805@redhat.com>
	<alpine.DEB.2.00.1210171219010.28214@chino.kir.corp.google.com>
	<20121017193229.GC16805@redhat.com>
	<alpine.DEB.2.00.1210171237130.28214@chino.kir.corp.google.com>
	<20121017194501.GA24400@redhat.com>
	<alpine.DEB.2.00.1210171318400.28214@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1210171428540.20712@chino.kir.corp.google.com>
	<507F803A.8000900@jp.fujitsu.com>
	<507F86BD.7070201@jp.fujitsu.com>
	<alpine.DEB.2.00.1210181255470.26994@chino.kir.corp.google.com>
	<508110C4.6030805@jp.fujitsu.com>
	<alpine.DEB.2.00.1210190227240.26815@chino.kir.corp.google.com>
	<5084B3C3.3070906@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012 11:47:31 +0900
Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> (2012/10/19 18:28), David Rientjes wrote:
> 
> > Looks good, but the patch is whitespace damaged so it doesn't apply.  When
> > that's fixed:
> >
> > Acked-by: David Rientjes <rientjes@google.com>
> 
> Sorry, I hope this one is not broken...
>
> ...
>
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -12,6 +12,7 @@
>   #include <linux/sched.h>
>   #include <linux/proc_fs.h>
>   struct  ctl_table_header;
> +struct  mempolicy;
>   
>   extern struct proc_dir_entry proc_root;
>   #ifdef CONFIG_PROC_SYSCTL
> @@ -74,6 +75,9 @@ struct proc_maps_private {
>   #ifdef CONFIG_MMU
>   	struct vm_area_struct *tail_vma;
>   #endif
> +#ifdef CONFIG_NUMA
> +	struct mempolicy *task_mempolicy;
> +#endif
>   };

The mail client space-stuffed it.

We merged this three days ago, in 9e7814404b77c3e8920b.  Please check
that it landed OK - there's a newline fixup in there but it looks good
to me.

