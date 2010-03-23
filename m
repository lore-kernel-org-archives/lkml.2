Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0CWQ1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:27:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35482 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab0CWQ11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:27:27 -0400
Date: Tue, 23 Mar 2010 13:27:19 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH -tip 10/10] perf probe: Accessing members in data
	structures
Message-ID: <20100323162719.GG4066@ghostprotocols.net>
References: <20100316220515.32050.82185.stgit@localhost6.localdomain6> <20100316220626.32050.57552.stgit@localhost6.localdomain6> <1268821537.6022.12.camel@springer.wildebeest.org> <4BA12A23.4030109@redhat.com> <20100318032804.GA5045@nowhere> <1269359713.5109.95.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269359713.5109.95.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 23, 2010 at 04:55:13PM +0100, Peter Zijlstra escreveu:
> On Thu, 2010-03-18 at 04:28 +0100, Frederic Weisbecker wrote:
> > On Wed, Mar 17, 2010 at 03:14:43PM -0400, Masami Hiramatsu wrote:
> > > Mark Wielaard wrote:
> > > > If you find that a problem then you can do like SystemTap does and allow
> > > > '.' in place of '->'. In the code you already use the
> > > > perf_probe_arg_field ref flag only to check that the DIE gives you the
> > > > same information. So you could just drop that and use any separator.
> > > > Then you decide based on whether you see a DW_TAG_pointer_type. This
> > > > gives the user some extra flexibility by letting them not having to care
> > > > about specifying extra type information already available elsewhere.

> > > Thanks, when designing this feature, I considered it too.

> > > Since perf probe already support displaying source code by --line option,
> > > users will read the probed code itself and try to probe it. In that case,
> > > I think they naturally use '.' and '->' as they read (they might try to
> > > copy & paste it).

> > > So, I think that it would be good to support both of '.' and '->' as
> > > they are used in the code, because it will not confuse users.

> > And lets people use what is common for them: expressions that follow
> > C rules in the context.

> > And those who will be more familiar with perf probe will know they can
> > use the simplified "." based scheme.

> I'd expect a syntax error when I mix up '.' and '->'.

Yup, I'd stick with following the C language rules.

- Arnaldo
