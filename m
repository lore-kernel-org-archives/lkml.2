Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab2KTPON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:14:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab2KTPOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:14:12 -0500
Date: Tue, 20 Nov 2012 12:13:44 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 1/3] perf session: Add perf_session__delete_env
Message-ID: <20121120151344.GA14928@infradead.org>
References: <1353403877-10730-1-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353403877-10730-1-git-send-email-feng.tang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 20, 2012 at 05:31:15PM +0800, Feng Tang escreveu:
> +static void perf_session__delete_env(struct perf_session *self)
> +{
> +	struct perf_session_env *env = &self->header.env;
> +
> +	free(env->hostname);
> +	free(env->os_release);
> +	free(env->version);
> +	free(env->arch);
> +	free(env->cpu_desc);
> +	free(env->cpuid);
> +
> +	free(env->cmdline);
> +	free(env->sibling_cores);
> +	free(env->sibling_threads);
> +	free(env->numa_nodes);
> +	free(env->pmu_mappings);
> +}

The object being deleted is a perf_session_env, so please make it
perf_session_env__delete(struct perf_session_env *env), and avoid using
'self'.

- Arnaldo
