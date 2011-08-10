Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1HJUZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 16:25:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53675 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab1HJUZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 16:25:38 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=ryAVDAa3YogA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=UXsgqqzdZeakFHdqRpUA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC 3/4] perf, ftrace: Add new perf ioctl for function trace
 filter
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110727121734.GB2605@jolsa.brq.redhat.com>
References: <1310390576-8289-1-git-send-email-jolsa@redhat.com>
	 <1310390576-8289-4-git-send-email-jolsa@redhat.com>
	 <20110718151229.GA32167@somewhere>
	 <20110719095727.GA3008@jolsa.brq.redhat.com>
	 <20110726134327.GA1779@somewhere>
	 <20110727121734.GB2605@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Aug 2011 16:25:35 -0400
Message-ID: <1313007935.18583.267.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, sorry for the late reply.

On Wed, 2011-07-27 at 14:17 +0200, Jiri Olsa wrote:
> On Tue, Jul 26, 2011 at 03:43:44PM +0200, Frederic Weisbecker wrote:
> 
> SNIP
> 
> > Ideally, the filter engine should split expressions into a tree
> > of ops:
> > 
> > 	ip == func1 + func2 + func3 || ip == func4
> > 
> > should be parsed into:
> > 
> >             ||
> >             /\
> >            /  \
> >           /    \
> >          /      \
> >         ==       ==
> >        /  \     /  \
> >       /    \   ip   \
> >      /      \       func4
> >     ip       +       
> >             / \
> >            /   \
> >           +     \
> >          /  \   func3
> >         /    \
> >     func1   func2
> > 
> > And then pass that to ftrace that interprets that tree
> > by building set of functions on top of each node joined to
> > the other.
> > 
> > But that can be complicated to do, and perhaps a bit of
> > an overkill even for daily use of it.
> > 
> > Having a simple "ip == func + func2 + func3" expression support
> 
> so the '+' is just shortcut for '||' ... like:

Please, lets use something other than '+', as it can also be construed
as addition, and will probably confuse things. Or we change the '==' to
'|=' or something, and then comma separate it?

ip |= func1, func2, func3

Where we can say the '|=' ',' pair is a short cut of multiple a == b
|| ..

-- Steve

> 
> "ip == x1 || ip == x1" AND "ip == x1 + x2" mean the same thing
> 
> if we omit the '+' and keep just the whitespace we could use the function
> name parser as used in set_ftrace_filter interface with no change ;)
> but adding new separator should not be that hard..
> 
> > should be enough I think. And we can reject expressions that don't
> > fit that pattern. Then if it becomes necessary one day to support
> > real expressions there, we can still switch to a real tree.
> > 
> > Does that look sane? 
> 
> I'l make the change and send new version
> 
> thanks,
> jirka


