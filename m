Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab1LAPxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:53:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50355 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab1LAPxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:53:36 -0500
Date: Thu, 1 Dec 2011 19:53:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in
 /proc/<pid>/status
Message-ID: <20111201155330.GV14515@moon>
References: <20111129191252.769160532@openvz.org>
 <20111129191638.835932727@openvz.org>
 <20111130140009.1ccd5af0.kamezawa.hiroyu@jp.fujitsu.com>
 <20111130060537.GK1775@moon>
 <20111201095434.GR14515@moon>
 <20111201154357.GA12668@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201154357.GA12668@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 07:43:57AM -0800, Tejun Heo wrote:
> > +
> > +int proc_pid_children(struct seq_file *m, struct pid_namespace *ns,
> > +		      struct pid *pid, struct task_struct *task)
> > +{
> > +	struct task_struct *c;
> > +
> > +	read_lock(&tasklist_lock);
> > +	list_for_each_entry(c, &task->children, sibling)
> > +		seq_printf(m, " %d", pid_nr_ns(task_pid(c), ns));
> > +	read_unlock(&tasklist_lock);
> > +	seq_putc(m, '\n');
> > +
> > +	return 0;
> > +}
> 
> I don't think using non-seekable single seqfile is a good idea here.
> It works if the whole list fits in PAGE_SIZE but assuming five digit
> pid, that's only ~680 pids.
> 

Hi Tejun, indeed this is not pleasant limit, thanks for the point,
I'll update! But other than this technical detail, I assume there is
no objection from introducing such feature?

	Cyrill
