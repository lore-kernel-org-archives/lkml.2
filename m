Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab2ASSDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 13:03:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932532Ab2ASSD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 13:03:29 -0500
Date: Thu, 19 Jan 2012 18:57:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH] fs, proc: Introduce /proc/<pid>/task/<tid>/children
	entry v7
Message-ID: <20120119175700.GA19627@redhat.com>
References: <20120119155112.GF31379@moon> <20120119174742.GD32568@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119174742.GD32568@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19, Cyrill Gorcunov wrote:
>
> On Thu, Jan 19, 2012 at 07:51:12PM +0400, Cyrill Gorcunov wrote:
> > If it's needed I can wrap all this with CONFIG_CHECKPOINT_RESTORE, should I?
> >
> > ---
>
> Oleg, if only I'm not missing something obvious you meant handling like below?

Yes, but...

> +struct proc_pid_children_iter {
> +	struct pid_namespace *pid_ns;
> +	struct pid *parent_pid;
> +};

you forgot to remove this definition.

> +static int children_seq_show(struct seq_file *seq, void *v)
> +{
> +	struct inode *inode = seq->private;
> +	unsigned long pid;
> +
> +	pid = (unsigned long)pid_nr_ns(v, inode->i_sb->s_fs_info);
> +	return seq_printf(seq, " %lu", pid);
> +}

just noticed... why unsigned long and %lu? afaics pid_t/%d should work
without any typecasts.

Oleg.

