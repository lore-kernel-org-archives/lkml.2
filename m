Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab2KTPVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:21:07 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55460 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab2KTPVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:21:01 -0500
Subject: Re: [PATCH 1/3] perf session: Add perf_session__delete_env
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Feng Tang <feng.tang@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>
In-Reply-To: <20121120151344.GA14928@infradead.org>
References: <1353403877-10730-1-git-send-email-feng.tang@intel.com>
	 <20121120151344.GA14928@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Nov 2012 00:20:54 +0900
Message-ID: <1353424854.1512.5.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-11-20 (화), 12:13 -0300, Arnaldo Carvalho de Melo:
> Em Tue, Nov 20, 2012 at 05:31:15PM +0800, Feng Tang escreveu:
> > +static void perf_session__delete_env(struct perf_session *self)
> > +{
> > +	struct perf_session_env *env = &self->header.env;
> > +
> > +	free(env->hostname);
> > +	free(env->os_release);
> > +	free(env->version);
> > +	free(env->arch);
> > +	free(env->cpu_desc);
> > +	free(env->cpuid);
> > +
> > +	free(env->cmdline);
> > +	free(env->sibling_cores);
> > +	free(env->sibling_threads);
> > +	free(env->numa_nodes);
> > +	free(env->pmu_mappings);
> > +}
> 
> The object being deleted is a perf_session_env, so please make it
> perf_session_env__delete(struct perf_session_env *env), and avoid using
> 'self'.

Okay, will do.

Thanks,
Namhyung


