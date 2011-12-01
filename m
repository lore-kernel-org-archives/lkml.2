Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab1LAPoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:44:08 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37424 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab1LAPoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:44:06 -0500
Date: Thu, 1 Dec 2011 07:43:57 -0800
From: Tejun Heo <tj@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in
 /proc/<pid>/status
Message-ID: <20111201154357.GA12668@google.com>
References: <20111129191252.769160532@openvz.org>
 <20111129191638.835932727@openvz.org>
 <20111130140009.1ccd5af0.kamezawa.hiroyu@jp.fujitsu.com>
 <20111130060537.GK1775@moon>
 <20111201095434.GR14515@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201095434.GR14515@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Cyrill.

On Thu, Dec 01, 2011 at 01:54:34PM +0400, Cyrill Gorcunov wrote:
> Index: linux-2.6.git/fs/proc/array.c
> ===================================================================
> --- linux-2.6.git.orig/fs/proc/array.c
> +++ linux-2.6.git/fs/proc/array.c
> @@ -547,3 +547,17 @@ int proc_pid_statm(struct seq_file *m, s
>  
>  	return 0;
>  }
> +
> +int proc_pid_children(struct seq_file *m, struct pid_namespace *ns,
> +		      struct pid *pid, struct task_struct *task)
> +{
> +	struct task_struct *c;
> +
> +	read_lock(&tasklist_lock);
> +	list_for_each_entry(c, &task->children, sibling)
> +		seq_printf(m, " %d", pid_nr_ns(task_pid(c), ns));
> +	read_unlock(&tasklist_lock);
> +	seq_putc(m, '\n');
> +
> +	return 0;
> +}

I don't think using non-seekable single seqfile is a good idea here.
It works if the whole list fits in PAGE_SIZE but assuming five digit
pid, that's only ~680 pids.

Thanks.

-- 
tejun
