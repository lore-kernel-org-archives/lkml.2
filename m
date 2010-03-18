Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab0CRD2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 23:28:07 -0400
Received: from mail-bw0-f212.google.com ([209.85.218.212]:36505 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab0CRD2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 23:28:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iHijp9HaDuLrzm1l+mQubUbsoUtWU0Z6cwhWxKMwP2GHHaOiHqAupeq1DMPptL7zth
         tN4nVyrn/zQHEvqXEUp6bseonaxmNorS6QvagCHtbw6SeuqV+T0Yce9kxR/Fe2EGrMqw
         x+cUpCuRh2/ogz0Kb5RJ1spJUonhhthmGkivg=
Date: Thu, 18 Mar 2010 04:28:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mark Wielaard <mjw@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip 10/10] perf probe: Accessing members in data
	structures
Message-ID: <20100318032804.GA5045@nowhere>
References: <20100316220515.32050.82185.stgit@localhost6.localdomain6> <20100316220626.32050.57552.stgit@localhost6.localdomain6> <1268821537.6022.12.camel@springer.wildebeest.org> <4BA12A23.4030109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA12A23.4030109@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 03:14:43PM -0400, Masami Hiramatsu wrote:
> Mark Wielaard wrote:
> > On Tue, 2010-03-16 at 18:06 -0400, Masami Hiramatsu wrote:
> >> Support accessing members in the data structures. With this,
> >> perf-probe accepts data-structure members(IOW, it now accepts
> >> dot '.' and arrow '->' operators) as probe arguemnts.
> >>
> >> e.g.
> >>
> >>  ./perf probe --add 'schedule:44 rq->curr'
> >>
> >>  ./perf probe --add 'vfs_read file->f_op->read file->f_path.dentry'
> >>
> >> Note that '>' can be interpreted as redirection in command-line.
> > 
> > If you find that a problem then you can do like SystemTap does and allow
> > '.' in place of '->'. In the code you already use the
> > perf_probe_arg_field ref flag only to check that the DIE gives you the
> > same information. So you could just drop that and use any separator.
> > Then you decide based on whether you see a DW_TAG_pointer_type. This
> > gives the user some extra flexibility by letting them not having to care
> > about specifying extra type information already available elsewhere.
> 
> Thanks, when designing this feature, I considered it too.
> 
> Since perf probe already support displaying source code by --line option,
> users will read the probed code itself and try to probe it. In that case,
> I think they naturally use '.' and '->' as they read (they might try to
> copy & paste it).
> 
> So, I think that it would be good to support both of '.' and '->' as
> they are used in the code, because it will not confuse users.
> 
> Thank you,


Agreed.

And lets people use what is common for them: expressions that follow
C rules in the context.

And those who will be more familiar with perf probe will know they can
use the simplified "." based scheme.

