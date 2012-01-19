Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab2ASSJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 13:09:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53758 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab2ASSJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 13:09:56 -0500
Date: Thu, 19 Jan 2012 22:09:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
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
Message-ID: <20120119180951.GI31379@moon>
References: <20120119155112.GF31379@moon>
 <20120119174742.GD32568@moon>
 <20120119175700.GA19627@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119175700.GA19627@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 06:57:00PM +0100, Oleg Nesterov wrote:
> On 01/19, Cyrill Gorcunov wrote:
> >
> > On Thu, Jan 19, 2012 at 07:51:12PM +0400, Cyrill Gorcunov wrote:
> > > If it's needed I can wrap all this with CONFIG_CHECKPOINT_RESTORE, should I?
> > >
> > > ---
> >
> > Oleg, if only I'm not missing something obvious you meant handling like below?
> 
> Yes, but...
> 
> > +struct proc_pid_children_iter {
> > +	struct pid_namespace *pid_ns;
> > +	struct pid *parent_pid;
> > +};
> 
> you forgot to remove this definition.
> 

No, I rather forgot to quilt refresh :)

> > +static int children_seq_show(struct seq_file *seq, void *v)
> > +{
> > +	struct inode *inode = seq->private;
> > +	unsigned long pid;
> > +
> > +	pid = (unsigned long)pid_nr_ns(v, inode->i_sb->s_fs_info);
> > +	return seq_printf(seq, " %lu", pid);
> > +}
> 
> just noticed... why unsigned long and %lu? afaics pid_t/%d should work
> without any typecasts.
> 

I'm not sure how important it is, but Andrew mentioned in one of email
that we might be moving from pid_t from int to long one day (which of
course will require extreme huge work on checking code where int->long
transition might cause problems). So I thought why should I wait then?

[ Andrew, am I correct? ]

But since I'll be refreshig patch anyway, I drop this.

	Cyrill
