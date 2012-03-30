Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761590Ab2C3VEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:04:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933677Ab2C3VD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:03:57 -0400
Message-ID: <4F761FB9.4070107@gmail.com>
Date: Fri, 30 Mar 2012 15:03:53 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] perf tools: Fix record sample overlap check for callchains
References: <1333129114-22117-1-git-send-email-andi@firstfloor.org> <1333129114-22117-2-git-send-email-andi@firstfloor.org>
In-Reply-To: <1333129114-22117-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/12 11:38 AM, Andi Kleen wrote:
> From: Andi Kleen<ak@linux.intel.com>
>
> perf record checks for buffer overflow, but checked for the wrong
> size for callchains.  callchains are 8 bytes each, not 1.
>
> Signed-off-by: Andi Kleen<ak@linux.intel.com>
> ---
>   tools/perf/util/evsel.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index f421f7c..90c0756 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -550,7 +550,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
>
>   		data->callchain = (struct ip_callchain *)array;
>
> -		if (sample_overlap(event, array, data->callchain->nr))
> +		if (sample_overlap(event, array, (1 + data->callchain->nr) * 8))

sizeof(u64) rather than the magic 8?

David

>   			return -EFAULT;
>
>   		array += 1 + data->callchain->nr;

