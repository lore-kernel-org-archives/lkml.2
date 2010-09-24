Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab0IXK4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 06:56:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab0IXK4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 06:56:47 -0400
Date: Fri, 24 Sep 2010 12:55:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: nhorman@tuxdriver.com, eugene@redhat.com, linux-kernel@vger.kernel.org,
        oleg@tv-sign.ru
Subject: Re: [RFC PATCH] proc: making "limits" world readable
Message-ID: <20100924105547.GA1818@jolsa.brq.redhat.com>
References: <1285060255-15784-1-git-send-email-jolsa@redhat.com>
 <20100923145642.49f17b20.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923145642.49f17b20.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 02:56:42PM -0700, Andrew Morton wrote:
> On Tue, 21 Sep 2010 11:10:55 +0200
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > hi,
> > 
> > I'd like to have the /proc/<pid>/limits file world readable,
> 
> Why?
> 

having this will ease the task of system management for large install
bases and where root privileges might be restricted

jirka

> > but I'm not sure this could cause some security issue.. thoughts?
> > 
> > The "limit" file was as a debug feature by following commit:
> > - proc: export a processes resource limits via /proc/pid
> >   commit d85f50d5e1aa99ab082035f94265847521819e58
> >   Author: Neil Horman <nhorman@tuxdriver.com>
> > 
> > 
> > thanks for any ideas,
> > jirka
> > ---
> >  fs/proc/base.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index a1c43e7..8e4adda 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -2675,7 +2675,7 @@ static const struct pid_entry tgid_base_stuff[] = {
> >  	INF("auxv",       S_IRUSR, proc_pid_auxv),
> >  	ONE("status",     S_IRUGO, proc_pid_status),
> >  	ONE("personality", S_IRUSR, proc_pid_personality),
> > -	INF("limits",	  S_IRUSR, proc_pid_limits),
> > +	INF("limits",	  S_IRUGO, proc_pid_limits),
> >  #ifdef CONFIG_SCHED_DEBUG
> >  	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
> >  #endif
> > @@ -3011,7 +3011,7 @@ static const struct pid_entry tid_base_stuff[] = {
> >  	INF("auxv",      S_IRUSR, proc_pid_auxv),
> >  	ONE("status",    S_IRUGO, proc_pid_status),
> >  	ONE("personality", S_IRUSR, proc_pid_personality),
> > -	INF("limits",	 S_IRUSR, proc_pid_limits),
> > +	INF("limits",	 S_IRUGO, proc_pid_limits),
> >  #ifdef CONFIG_SCHED_DEBUG
> >  	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
> >  #endif
> 
