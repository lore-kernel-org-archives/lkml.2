Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2BOSHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 13:07:38 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63704 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab2BOSHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 13:07:37 -0500
Date: Wed, 15 Feb 2012 16:07:26 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Stephen Wilson <wilsons@start.ca>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Tejun Heo <tj@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>, sonnyrao@chromium.org,
        olofj@chromium.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Luigi Semenzato <semenzato@chromium.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] Perf: bug fix: distinguish between rename and exec
Message-ID: <20120215180726.GO28614@infradead.org>
References: <1329195360-10699-1-git-send-email-semenzato@chromium.org>
 <1329310113.2293.72.camel@twins>
 <CABPqkBTJHOsSfMBMW17reBObLW0bphWZo4AjVh_hTkv5tBHtDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTJHOsSfMBMW17reBObLW0bphWZo4AjVh_hTkv5tBHtDA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 15, 2012 at 06:59:38PM +0100, Stephane Eranian escreveu:
> On Feb 15, 2012 1:48 PM, "Peter Zijlstra" <a.p.zijlstra@chello.nl> wrote:
> > I really dislike changing generic code purely for the purpose of
> > instrumentation like this. Better to pull perf_event_comm() out of here
> > if you want to change semantics.
> >
> > Personally I couldn't care less about renames, I think they're a waste
> > of time, so I'm ok with the simple patch moving the perf_event_comm()
> > into setup_new_exec() and possibly renaming it to perf_event_exec().

> I tend to agree with you on this.
> Is there anything that depends on renames
> In perf?

Look at thread__set_comm, not intuitive, goes back to the original
problem description by Luigi.

- Arnaldo
