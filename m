Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161579Ab2CSSMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 14:12:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39166 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695Ab2CSSMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 14:12:44 -0400
Date: Mon, 19 Mar 2012 15:12:37 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Colin Walters <walters@verbum.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report'
 browser
Message-ID: <20120319181237.GB21538@infradead.org>
References: <1330013922-3332-1-git-send-email-penberg@kernel.org>
 <1330025802.17301.1.camel@lenny>
 <CAOJsxLEQ0VNsTEApsWQHC4G4199xm31UkWt1n0fqh3tZVa2f8A@mail.gmail.com>
 <1330029238.17301.3.camel@lenny>
 <CAOJsxLEksW5Jn=xF+mFmKswRDny+ZfBTYRYUarzn_fmNcpk_OQ@mail.gmail.com>
 <20120224094812.GF814@elte.hu>
 <CAOJsxLFv=Pq0iHrUQsK7gghhrmwBB=BqzY--RhisbjUZuLMEyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLFv=Pq0iHrUQsK7gghhrmwBB=BqzY--RhisbjUZuLMEyg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 24, 2012 at 12:05:56PM +0200, Pekka Enberg escreveu:
> On Fri, Feb 24, 2012 at 11:48 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > * Pekka Enberg <penberg@kernel.org> wrote:
> >
> >> On Thu, Feb 23, 2012 at 10:33 PM, Colin Walters <walters@verbum.org> wrote:
> >> >> Sure. We don't want to do that for all files. Just for the ones that
> >> >> include <gtk/gtk.h>.
> >> >
> >> > #pragma GCC diagnostic push
> >> > #pragma GCC diagnostic ignored "-Wstrict-prototypes"
> >> > #include <gtk/gtk.h>
> >> > #pragma GCC diagnostic pop
> >>
> >> It's cleaner to do it at Makefile level. We should do
> >> something like sparse.git Makefile does where you can
> >> optionally specify CFLAGS for individual source files.
> >
> > I actually like the #pragma hack because it only turns off the
> > check for that broken header and keeps our checks in place for
> > the rest of the .c file.
> >
> > Could be turned into a util/gtk.h file that is included instead
> > of <gtk/gtk.h>, so that we don't have to see the #pragma
> > workaround all the time?
> 
> Sure, makes sense.

Using just:

#pragma GCC diagnostic ignored "-Wstrict-prototypes"
#include <gtk/gtk.h>
#pragma GCC diagnostic error "-Wstrict-prototypes"

Since push/pop was introduced in gcc 4.6, and here at the test machine
using RHEL6.2 I have gcc 4.4.6.

- Arnaldo
