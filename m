Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2ASOrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:47:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61699 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2ASOrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:47:08 -0500
Date: Thu, 19 Jan 2012 18:47:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children entry
 v6
Message-ID: <20120119144700.GE31379@moon>
References: <20120116153231.GF2998@moon>
 <4F15EA53.8030405@gmail.com>
 <20120118135809.GA10105@redhat.com>
 <20120118142156.GR1968@moon>
 <20120118143631.GA11776@redhat.com>
 <20120118182344.GD2889@moon>
 <20120118190725.GE2889@moon>
 <20120119141051.GA9652@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119141051.GA9652@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 03:10:51PM +0100, Oleg Nesterov wrote:
> On 01/18, Cyrill Gorcunov wrote:
> >
> > I suppose it might be something like below. I've updated comment and
> > quoted your comment there just I wont forget this next time I'll be
> > reading the source. Thanks!
> 
> I believe the patrch is correct.
> 
> But... Cyrill, I am wondering how much will you hate me if I make
> yet another attempt to delay this patch.
> 

I'm ready to do any iterations until patch become correct. It's better
to spend some time now than later.

> > +static int children_seq_open(struct inode *inode, struct file *file)
> > +{
> > +	struct proc_pid_children_iter *iter = NULL;
> > +	struct task_struct *task = NULL;
> > +	int ret = 0;
> > +
> > +	task = get_proc_task(inode);
> > +	if (!task) {
> > +		ret = -ENOENT;
> > +		goto err;
> > +	}
> 
> For what??
> 
> > +	if (!ret) {
> > +		struct seq_file *m = file->private_data;
> > +		m->private = iter;
> > +
> > +		iter->pid_start = get_pid(task_pid(task));
> 
> This is what we need, right? So can't we remove this "task_struct *task"
> and simply do
> 
> 		iter->pid_start = get_ppid(proc_pid(inode));
> 

Yeah, this one will be cleaner. Thanks!

> ?
> 
> And while this is absolutely cosmetic probably ->parent_pid is
> a bit better name, but this is up to you.
> 

Yeah, I'll change the name, I liked this one more.

	Cyrill
