Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab2IGQul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:50:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34442 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2IGQuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:50:39 -0400
Message-ID: <504A25DB.2030100@gmail.com>
Date: Fri, 07 Sep 2012 10:50:35 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, ibs: Check syscall attribute flags
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com> <1342826756-64663-9-git-send-email-dsahern@gmail.com> <20120906190238.GA29278@erda.amd.com> <5048F6BF.70106@gmail.com> <20120906195645.GD8285@erda.amd.com> <20120907164114.GJ8285@erda.amd.com>
In-Reply-To: <20120907164114.GJ8285@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/7/12 10:41 AM, Robert Richter wrote:
> +	struct perf_event_attr notsupp = {
> +		.exclude_user	= 1,
> +		.exclude_kernel	= 1,
> +		.exclude_hv	= 1,
> +		.exclude_idle	= 1,
> +		.exclude_host	= 1,
> +		.exclude_guest	= 1,
> +	};
>
>   	perf_ibs = get_ibs_pmu(event->attr.type);
>   	if (perf_ibs) {
> @@ -229,6 +237,9 @@ static int perf_ibs_init(struct perf_event *event)
>   	if (event->pmu != &perf_ibs->pmu)
>   		return -ENOENT;
>
> +	if (perf_flags(&event->attr) & perf_flags(&notsupp))
> +		return -EINVAL;
> +

Am I reading this right - if exclude_guest is set then perf_ibs_init 
returns -EINVAL?

David

