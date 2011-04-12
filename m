Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab1DLX7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 19:59:42 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:41875 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1DLX7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 19:59:41 -0400
Date: Tue, 12 Apr 2011 19:59:11 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, ebiederm@xmission.com,
        lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com,
        oleg@redhat.com, David Rientjes <rientjes@google.com>,
        Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v8.75 0/4] cgroups: implement moving a threadgroup's
 threads atomically with cgroup.procs
Message-ID: <20110412235911.GB3804@ghc17.ghc.andrew.cmu.edu>
References: <20110208013542.GC31569@ghc17.ghc.andrew.cmu.edu>
 <20110406194420.GC10792@ghc17.ghc.andrew.cmu.edu>
 <20110412162516.4120c441.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412162516.4120c441.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.3.18.170322
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1300_1399 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 04:25:16PM -0700, Andrew Morton wrote:
> On Wed, 6 Apr 2011 15:44:20 -0400
> Ben Blum <bblum@andrew.cmu.edu> wrote:
> 
> > Same as before; using flex_array in attach_proc (thanks Kame).
> > 
> > -- Ben
> > 
> > ---
> >  Documentation/cgroups/cgroups.txt |   39 ++-
> >  block/blk-cgroup.c                |   18 -
> >  include/linux/cgroup.h            |   10 
> >  include/linux/init_task.h         |    9 
> >  include/linux/sched.h             |   36 ++
> >  kernel/cgroup.c                   |  489 +++++++++++++++++++++++++++++++++-----
> >  kernel/cgroup_freezer.c           |   26 --
> >  kernel/cpuset.c                   |   96 +++----
> >  kernel/fork.c                     |   10 
> >  kernel/sched.c                    |   38 --
> >  mm/memcontrol.c                   |   18 -
> >  security/device_cgroup.c          |    3 
> >  12 files changed, 594 insertions(+), 198 deletions(-)
> 
> So where are we up to with all this.

done and good to go, hopefully? :O

> 
> I'm surprised that none of the patches had anyone's Acked-by: or
> Reviewed-by:.  Were they really that mean to you, or have you not been
> tracking these?
> 
> 

Oh, eep. I didn't think to put them there myself; I guess I was assuming
they'd either be implicit or that my reviewers would have something more
to say.

Thanks!

-- Ben
