Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab1LBRHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 12:07:51 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58942 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895Ab1LBRHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 12:07:50 -0500
Message-ID: <4ED905DF.2000501@gmail.com>
Date: Fri, 02 Dec 2011 10:07:43 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/4] perf test: Validate PERF_RECORD_ events and perf_sample
 fields
References: <1322842769-7232-1-git-send-email-acme@infradead.org> <1322842769-7232-5-git-send-email-acme@infradead.org>
In-Reply-To: <1322842769-7232-5-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/02/2011 09:19 AM, Arnaldo Carvalho de Melo wrote:
> +found_exit:
> +	if (nr_events[PERF_RECORD_COMM] > 1) {
> +		pr_debug("Excessive number of PERF_RECORD_COMM events!\n");
> +		goto out_err;
> +	}
> +
> +	if (nr_events[PERF_RECORD_COMM] == 0) {
> +		pr_debug("Missing PERF_RECORD_COMM for %s!\n", cmd);
> +		goto out_err;
> +	}
> +
> +	if (!found_cmd_mmap) {
> +		pr_debug("PERF_RECORD_MMAP for %s missing!\n", cmd);
> +		goto out_err;
> +	}
> +
> +	if (!found_libc_mmap) {
> +		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "libc");
> +		goto out_err;
> +	}
> +
> +	if (!found_ld_mmap) {
> +		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "ld");
> +		goto out_err;
> +	}
> +
> +	if (!found_vdso_mmap) {
> +		pr_debug("PERF_RECORD_MMAP for %s missing!\n", "[vdso]");
> +		goto out_err;
> +	}


Since this is a test why not show all missed events rather than punt to
out_err on the first missed one?

David


> +
> +	err = 0;
> +out_err:
> +	perf_evlist__munmap(evlist);
> +out_free_cpu_mask:
> +	CPU_FREE(cpu_mask);
> +out_delete_evlist:
> +	perf_evlist__delete(evlist);
> +out:
> +	return err;
> +}
> +
