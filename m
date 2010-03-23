Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab0CWPzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:55:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:49993 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab0CWPzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:55:35 -0400
Subject: Re: [PATCH -tip 10/10] perf probe: Accessing members in data
 structures
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <20100318032804.GA5045@nowhere>
References: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
	 <20100316220626.32050.57552.stgit@localhost6.localdomain6>
	 <1268821537.6022.12.camel@springer.wildebeest.org>
	 <4BA12A23.4030109@redhat.com>  <20100318032804.GA5045@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Mar 2010 16:55:13 +0100
Message-ID: <1269359713.5109.95.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-18 at 04:28 +0100, Frederic Weisbecker wrote:
> On Wed, Mar 17, 2010 at 03:14:43PM -0400, Masami Hiramatsu wrote:
> > Mark Wielaard wrote:
> > > On Tue, 2010-03-16 at 18:06 -0400, Masami Hiramatsu wrote:
> > >> Support accessing members in the data structures. With this,
> > >> perf-probe accepts data-structure members(IOW, it now accepts
> > >> dot '.' and arrow '->' operators) as probe arguemnts.
> > >>
> > >> e.g.
> > >>
> > >>  ./perf probe --add 'schedule:44 rq->curr'
> > >>
> > >>  ./perf probe --add 'vfs_read file->f_op->read file->f_path.dentry'
> > >>
> > >> Note that '>' can be interpreted as redirection in command-line.
> > > 
> > > If you find that a problem then you can do like SystemTap does and allow
> > > '.' in place of '->'. In the code you already use the
> > > perf_probe_arg_field ref flag only to check that the DIE gives you the
> > > same information. So you could just drop that and use any separator.
> > > Then you decide based on whether you see a DW_TAG_pointer_type. This
> > > gives the user some extra flexibility by letting them not having to care
> > > about specifying extra type information already available elsewhere.
> > 
> > Thanks, when designing this feature, I considered it too.
> > 
> > Since perf probe already support displaying source code by --line option,
> > users will read the probed code itself and try to probe it. In that case,
> > I think they naturally use '.' and '->' as they read (they might try to
> > copy & paste it).
> > 
> > So, I think that it would be good to support both of '.' and '->' as
> > they are used in the code, because it will not confuse users.
> > 
> > Thank you,
> 
> 
> Agreed.
> 
> And lets people use what is common for them: expressions that follow
> C rules in the context.
> 
> And those who will be more familiar with perf probe will know they can
> use the simplified "." based scheme.

I'd expect a syntax error when I mix up '.' and '->'.
