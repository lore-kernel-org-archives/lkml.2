Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab1BJDmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 22:42:03 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:57333 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755023Ab1BJDl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 22:41:59 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/SxjUWM+vSsoz35WFUveNnD826uMH68CDN7bsh+b
	KYH3PFMnzhzLBq
Subject: Re: [tip:perf/core] perf annotate: Fix annotate context lines
 regression
From: Mike Galbraith <efault@gmx.de>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20110209164154.GA15607@ghostprotocols.net>
References: <new-submission>
	 <tip-d5e3d747007fdb541e57ed72e020ff0b94db3470@git.kernel.org>
	 <1297224378.8035.7.camel@marge.simson.net>
	 <20110209164154.GA15607@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 04:41:53 +0100
Message-ID: <1297309313.7996.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 14:41 -0200, Arnaldo Carvalho de Melo wrote:
> Em Wed, Feb 09, 2011 at 05:06:18AM +0100, Mike Galbraith escreveu:
> > On Wed, 2011-02-09 at 00:43 +0000, tip-bot for Arnaldo Carvalho de Melo wrote
> > > Gitweb:     http://git.kernel.org/tip/d5e3d747007fdb541e57ed72e020ff0b94db3470
> > > Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
> > > 
> > > perf annotate: Fix annotate context lines regression
> > > 
> > > The live annotation done in 'perf top' needs to limit the context before
> > > lines that aren't filtered out by the min percent filter, if we don't do
> > > that, the screen in a tty often is not enough for showing what is
> > > interesting: lines with hits and a few source code lines before it.
> > 
> > Looks to me like this went from regress a bit while waiting for tui
> > thing to progress a bit immediately :)
> 
> :-) Can you please apply the two patches and give 'perf top --tui' live
> annotation a shot? Just press enter or -> (right key) on a symbol you
> want to annotate.
> 
> I'm still polishing it a bit, want to avoid trying the notes->lock on
> each time record_precise_ip is called, for that I need to share the
> current symbol being annotated (sym_filter_entry) with the annotate
> browser, the timer should not always run, etc, but just so that I can
> get some feedback on how it is shaping up, please try it and report your
> impressions :-)

Initial impression: can I have a pony too? :)

I like this a lot, great for live rummaging.   One thing that would help
with large files maybe - a jump to next spot hotter than N%, but as is
is quite nice.

I managed to lock it up once, but shiny new gizmos usually do hiccup.

	-Mike

