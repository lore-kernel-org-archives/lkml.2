Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab2CMNoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:44:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35932 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2CMNoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:44:06 -0400
Date: Tue, 13 Mar 2012 14:44:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 2/2] perf: Add a new sort order: SORT_INCLUSIVE
Message-ID: <20120313134357.GA24028@somewhere.redhat.com>
References: <1331160079-13821-1-git-send-email-asharma@fb.com>
 <1331160079-13821-3-git-send-email-asharma@fb.com>
 <20120308153933.GD7976@somewhere.redhat.com>
 <20120308182226.GA10065@dev3310.snc6.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308182226.GA10065@dev3310.snc6.facebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 10:22:26AM -0800, Arun Sharma wrote:
> On Thu, Mar 08, 2012 at 04:39:36PM +0100, Frederic Weisbecker wrote:
> > 
> > I don't yet understand the point of this.
> > 
> > Imagine those three hists:
> > 
> > a -> b -> c
> > a -> b -> d
> > a-> e -> f
> > 
> > The fractal inverted mode (-G) will report this:
> > 
> > a--
> >   |
> >   ----- b
> >   |     |
> >   |     -----c
> >   |     |
> >   |     -----d
> >   |
> >   ----- e
> >         |
> >         -----f
> > 
> 
> Please see the test program attached. It has only two paths from main()
> to c(). But for this discussion, imagine a callgraph with 10 different
> paths.

Ok that makes sense.

Thanks.

> 
> With -G, c() appears 10 times in the callgraph and the user is required
> to manually sum up the samples to realize that the callgraph under c()
> is very expensive.
> 
> With -s inclusive, c() will show up at the very top after main().
> 
>  -Arun
> 
> #include <stdio.h>
> 
> int sum = 0;
> 
> #define LOOP(n)                                         \
>         {                                               \
>                 int j;                                  \
>                 for (j = 0; j < 10000; j++) {           \
>                         sum += j;                       \
>                 }                                       \
>         }
> 
> int f()
> {
>         LOOP(100);
> }
> 
> int d()
> {
>         LOOP(100);
>         f();
> }
> 
> int e()
> {
> 	LOOP(100);
> 	f();
> }
> 
> int c()
> {
> 	LOOP(100);
> 	d();
> 	LOOP(100);
> 	e();
> }
> 
> int b() 
> {
> 	LOOP(70);
> 	c();
> }
> 
> int a() 
> {
> 	LOOP(30);
> 	c();
> }
> 
> int main()
> {
> 	int i;
> 	for (i = 0; i < 10000; i++) {
> 		a();
> 		b();
> 	}
> }
> 
