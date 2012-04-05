Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab2DEQ7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:59:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43676 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab2DEQ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:59:09 -0400
Message-ID: <4F7DCF58.8020601@gmail.com>
Date: Thu, 05 Apr 2012 10:59:04 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf tools: Use sw counter only if hw pmu is not
 detected
References: <1333643188-26895-1-git-send-email-robert.richter@amd.com> <1333643188-26895-5-git-send-email-robert.richter@amd.com>
In-Reply-To: <1333643188-26895-5-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/12 10:26 AM, Robert Richter wrote:
> Use cpu-clock-tick sw counter for cpu-cycles only if there is no hw
> pmu available. This is the case if the syscall reports ENOENT. In
> other cases (e.g. invalid attributes) we don't want the sw counter to
> be used.

Isn't the invalid attributes case handled by the
'} else if (err == EINVAL) {'
case before this switch is done?

David


>
> Signed-off-by: Robert Richter<robert.richter@amd.com>
> ---
>   tools/perf/builtin-record.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index be4e1ee..10b1f1f 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -245,7 +245,7 @@ try_again:
>   			 * based cpu-clock-tick sw counter, which
>   			 * is always available even if no PMU support:
>   			 */
> -			if (attr->type == PERF_TYPE_HARDWARE
> +			if (err == ENOENT&&  attr->type == PERF_TYPE_HARDWARE
>   					&&  attr->config == PERF_COUNT_HW_CPU_CYCLES) {
>
>   				if (verbose)

