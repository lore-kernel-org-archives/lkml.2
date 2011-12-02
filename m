Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab1LBAYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 19:24:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52949 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab1LBAYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 19:24:12 -0500
Date: Fri, 2 Dec 2011 03:24:06 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 1/3] fs, proc: Add start_data, end_data, start_brk members
 to /proc/$pid/stat
Message-ID: <20111202002405.GA7701@p183.telecom.by>
References: <20111129191252.769160532@openvz.org>
 <20111129191638.756761754@openvz.org>
 <20111129200627.GO5169@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129200627.GO5169@outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 12:06:27PM -0800, Kees Cook wrote:
> On Tue, Nov 29, 2011 at 11:12:53PM +0400, Cyrill Gorcunov wrote:
> > It helps to dump and restore this mm_struct members.
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > ---
> >  fs/proc/array.c |    7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6.git/fs/proc/array.c
> > ===================================================================
> > --- linux-2.6.git.orig/fs/proc/array.c
> > +++ linux-2.6.git/fs/proc/array.c
> > @@ -464,7 +464,7 @@ static int do_task_stat(struct seq_file
> >  
> >  	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
> >  %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
> > -%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
> > +%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
> >  		pid_nr_ns(pid, ns),
> >  		tcomm,
> >  		state,
> > @@ -511,7 +511,10 @@ static int do_task_stat(struct seq_file
> >  		task->policy,
> >  		(unsigned long long)delayacct_blkio_ticks(task),
> >  		cputime_to_clock_t(gtime),
> > -		cputime_to_clock_t(cgtime));
> > +		cputime_to_clock_t(cgtime),
> > +		mm ? (permitted ? mm->start_data : 1) : 0,
> > +		mm ? (permitted ? mm->end_data : 1) : 0,
> > +		mm ? (permitted ? mm->start_brk : 1) : 0);
> >  	if (mm)
> >  		mmput(mm);
> >  	return 0;
> 
> Thanks for using "permitted" here. :)

And these are new fields, so "1" hack is unnecessary.
