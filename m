Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab2BXJsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 04:48:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41442 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab2BXJsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 04:48:20 -0500
Date: Fri, 24 Feb 2012 10:48:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Colin Walters <walters@verbum.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report'
 browser
Message-ID: <20120224094812.GF814@elte.hu>
References: <1330013922-3332-1-git-send-email-penberg@kernel.org>
 <1330025802.17301.1.camel@lenny>
 <CAOJsxLEQ0VNsTEApsWQHC4G4199xm31UkWt1n0fqh3tZVa2f8A@mail.gmail.com>
 <1330029238.17301.3.camel@lenny>
 <CAOJsxLEksW5Jn=xF+mFmKswRDny+ZfBTYRYUarzn_fmNcpk_OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLEksW5Jn=xF+mFmKswRDny+ZfBTYRYUarzn_fmNcpk_OQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> On Thu, Feb 23, 2012 at 10:33 PM, Colin Walters <walters@verbum.org> wrote:
> >> Sure. We don't want to do that for all files. Just for the ones that
> >> include <gtk/gtk.h>.
> >
> > #pragma GCC diagnostic push
> > #pragma GCC diagnostic ignored "-Wstrict-prototypes"
> > #include <gtk/gtk.h>
> > #pragma GCC diagnostic pop
> 
> It's cleaner to do it at Makefile level. We should do 
> something like sparse.git Makefile does where you can 
> optionally specify CFLAGS for individual source files.

I actually like the #pragma hack because it only turns off the 
check for that broken header and keeps our checks in place for 
the rest of the .c file.

Could be turned into a util/gtk.h file that is included instead 
of <gtk/gtk.h>, so that we don't have to see the #pragma 
workaround all the time?

Thanks,

	Ingo
