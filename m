Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab2ATGbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 01:31:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62023 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2ATGbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 01:31:32 -0500
Date: Fri, 20 Jan 2012 10:31:26 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH] fs, proc: Introduce /proc/<pid>/task/<tid>/children
 entry v7
Message-ID: <20120120063126.GA1954@moon>
References: <20120119155112.GF31379@moon>
 <20120119174742.GD32568@moon>
 <20120119175700.GA19627@redhat.com>
 <20120119180951.GI31379@moon>
 <m1ty3r1e0y.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ty3r1e0y.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 03:14:05PM -0800, Eric W. Biederman wrote:
...
> >
> >> > +static int children_seq_show(struct seq_file *seq, void *v)
> >> > +{
> >> > +	struct inode *inode = seq->private;
> >> > +	unsigned long pid;
> >> > +
> >> > +	pid = (unsigned long)pid_nr_ns(v, inode->i_sb->s_fs_info);
> >> > +	return seq_printf(seq, " %lu", pid);
> >> > +}
> >> 
> >> just noticed... why unsigned long and %lu? afaics pid_t/%d should work
> >> without any typecasts.
> >> 
> >
> > I'm not sure how important it is, but Andrew mentioned in one of email
> > that we might be moving from pid_t from int to long one day (which of
> > course will require extreme huge work on checking code where int->long
> > transition might cause problems). So I thought why should I wait then?
> >
> > [ Andrew, am I correct? ]
> 
> It is going to take a lot to get to a > 32bit pid value.  I would not
> worry about it today unless there is some 64bit arch somewhere that defines
> pid_t as long.
> 

Yeah, it seems I overdone here ;) I've sent updated version with pid_t.

	Cyrill
