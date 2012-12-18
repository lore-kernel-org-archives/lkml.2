Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2LRBMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:12:09 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57293 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab2LRBMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:12:08 -0500
X-AuditID: 9c93016f-b7b74ae000000e39-d6-50cfc2e3139d
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/3] perf tool: Add support to include non architectural event aliases
References: <1355751425-7993-1-git-send-email-jolsa@redhat.com>
	<1355751425-7993-3-git-send-email-jolsa@redhat.com>
Date: Tue, 18 Dec 2012 10:12:03 +0900
In-Reply-To: <1355751425-7993-3-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Mon, 17 Dec 2012 14:37:04 +0100")
Message-ID: <871ueokvto.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, 17 Dec 2012 14:37:04 +0100, Jiri Olsa wrote:
> Adding support to parse non architectural event aliases
> for given cpu. These aliases will be provided as 'events'
> directory like architectural ones provided by kernel.
>
[snip]
> +
> +$(OUTPUT)$(OUTPUT)arch/$(ARCH)/util/pmu.o: $(OUTPUT)arch/$(ARCH)/util/pmu.c $(OUTPUT)PERF-CFLAGS

Double OUTPUT ? ;)


> +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
> +	 '-DPERF_EXEC_PATH="$(perfexecdir_SQ)"' \
> +	 '-DPREFIX="$(prefix_SQ)"' \
> +	 $<
[snip]
> +static int cpu_aliases(struct list_head *head)
> +{
> +	unsigned vendol, model;

s/vendol/vendor/ ?

Thanks,
Namhyung


> +	int ret;
> +
> +	ret = cpu_specs(&vendol, &model);
> +	if (ret) {
> +		pr_info("failed to get cpu aliases");
> +		return 0;
> +	}
> +
> +	switch (vendol) {
> +	/* Intel */
> +	case 0:
> +		return intel_aliases(head, model);
> +	default:
> +		/* unknown vendor.. plenty to cover ;-) */
> +		return 0;
> +	}
> +
> +	return 0;
> +}
