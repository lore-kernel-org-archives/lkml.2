Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab0CPK0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 06:26:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44311 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757793Ab0CPKZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 06:25:59 -0400
Date: Tue, 16 Mar 2010 11:25:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: T??r??k Edwin <edwintorok@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf: install into /usr/local by default.
Message-ID: <20100316102546.GE10069@elte.hu>
References: <4B9F3EEC.7050104@gmail.com>
 <1268733435-30225-1-git-send-email-edwintorok@gmail.com>
 <20100316101031.GL7961@elte.hu>
 <4B9F5B6E.5040302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9F5B6E.5040302@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 03/16/2010 12:10 PM, Ingo Molnar wrote:
> >* T??r??k Edwin<edwintorok@gmail.com>  wrote:
> >
> >>It was confusing to install into $(HOME)/bin, especially since there was
> >>no documentation mentioning where perf gets installed by default.
> >>So install to /usr/local by default, as other programs do, and allow users to
> >>override the install location by specifying the prefix explicitly.
> >>
> >>Signed-off-by: T??r??k Edwin<edwintorok@gmail.com>
> >>---
> >>  tools/perf/Makefile |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >>diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> >>index 2e7fa3a..8e8c199 100644
> >>--- a/tools/perf/Makefile
> >>+++ b/tools/perf/Makefile
> >>@@ -216,7 +216,7 @@ STRIP ?= strip
> >>  # runtime figures out where they are based on the path to the executable.
> >>  # This can help installing the suite in a relocatable way.
> >>
> >>-prefix = $(HOME)
> >>+prefix = /usr/local
> >>  bindir_relative = bin
> >>  bindir = $(prefix)/$(bindir_relative)
> >>  mandir = share/man
> >Btw., we inherited that default prefix from the Git project.
> >
> >Is there a way to get it into ~/bin/ if the user does not have permission to
> >/usr/local ? (i.e. doesnt run it as root)
> >
> >That's a really convenient aspect of doing a 'make install' as user. (Which i
> >tend to do in most cases)
> 
> What about people (like me) who do 'make && sudo make install'?

I'd like everyone to be happy :-)

In case of irreconcilable differences i prefer the creation of two parallel 
universes, one for each variant. This does not seem to be such a case though:

> Can we make it position independent and derive the path from /proc/$$/exe?

Sounds like a useful approach ...

	Ingo
