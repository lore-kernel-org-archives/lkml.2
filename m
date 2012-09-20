Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab2ITLnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:43:16 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58474 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab2ITLnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:43:14 -0400
Date: Thu, 20 Sep 2012 04:43:07 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 1/4] perf header: Add struct perf_header_info
Message-ID: <20120920114307.GB11325@ghostprotocols.net>
References: <1348119407-12528-1-git-send-email-namhyung@kernel.org>
 <1348119407-12528-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348119407-12528-2-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 20, 2012 at 02:36:44PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The struct perf_header_info will preserve environment information at
> the time of perf record.  It can be accessed anytime after parsing a
> perf.data file if needed.
 
> +struct perf_header_info {

I think it would be better named as 'perf_session_env' i.e. the
environment (machine (name), hardware(nr_cpus, total_mem, etc) and
OS(release, version) details) where a 'perf' 'session' took place.

perf 'header info' look more like 'what is the version in the header?
what about its endianity, and other 'header' details :-)

> +	char			*hostname;
> +	char			*os_release;
> +	char			*version;
> +	char			*arch;
> +	int			nr_cpus_online;
> +	int			nr_cpus_avail;
> +	char			*cpu_desc;
> +	char			*cpuid;
> +	unsigned long long	total_mem;
> +
> +	int			nr_cmdline;
> +	char			*cmdline;
> +	int			nr_sibling_cores;
> +	char			*sibling_cores;
> +	int			nr_sibling_threads;
> +	char			*sibling_threads;
> +	int			nr_numa_nodes;
> +	char			*numa_nodes;
> +	int			nr_pmu_mappings;
> +	char			*pmu_mappings;
> +};
> +
>  struct perf_header {
>  	int			frozen;
>  	bool			needs_swap;
> @@ -67,6 +90,7 @@ struct perf_header {
>  	u64			event_offset;
>  	u64			event_size;
>  	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
> +	struct perf_header_info info;
>  };
>  
>  struct perf_evlist;
> -- 
> 1.7.11.4
