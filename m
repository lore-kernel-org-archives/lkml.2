Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab2HAO0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:26:19 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43567 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab2HAO0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:26:18 -0400
Message-ID: <50193C83.6050503@gmail.com>
Date: Wed, 01 Aug 2012 08:26:11 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 13/13] perf, tool: Support for dwarf mode callchain on
 perf record
References: <1343815865-5511-1-git-send-email-jolsa@redhat.com> <1343815865-5511-14-git-send-email-jolsa@redhat.com>
In-Reply-To: <1343815865-5511-14-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/12 4:11 AM, Jiri Olsa wrote:
> +static int
> +parse_callchain_opt(const struct option *opt __used, const char *arg,
> +		    int unset)
> +{
> +	struct perf_record *rec = (struct perf_record *)opt->value;
> +	char *tok, *name, *saveptr = NULL;
> +	char buf[20];
> +	int ret = -1;
> +
> +	/* --no-call-graph */
> +	if (unset)
> +		return 0;
> +
> +	/* We specified default option if none is provided. */
> +	BUG_ON(!arg);
> +
> +	/* We need buffer that we know we can write to. */
> +	snprintf(buf, 20, "%s", arg);

Isn't arg the user supplied string? What if the user messes up and 
passes in 20+ characters to -g argument?

David
