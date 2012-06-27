Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2F0NG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:06:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46709 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab2F0NG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:06:56 -0400
MIME-Version: 1.0
In-Reply-To: <1340780953-21130-1-git-send-email-zheng.z.yan@intel.com>
References: <1340780953-21130-1-git-send-email-zheng.z.yan@intel.com>
Date: Wed, 27 Jun 2012 15:06:54 +0200
Message-ID: <CABPqkBRYcpxUX+j=roJKwmFMbdfoHf0APwusEEG6BS6cU_U+zQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf/x86: Use 0xff as pseudo code for fixed uncore event
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 9:09 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>
> Stephane Eranian suggestted using 0xff as pseudo code for fixed
> uncore event and using the umask value to determine which of the
> fixed events we want to map to. So far there is at most one fixed
> counter in a uncore PMU. So just change the definition of
> UNCORE_FIXED_EVENT to 0xff.
>
I would still do: event=0xff,umask=0x00
to reinforce the fact that first fixed counter is index 0x00.

> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c |    4 ++--
>  arch/x86/kernel/cpu/perf_event_intel_uncore.h |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index 6f43f95..8ca0f8f 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -179,7 +179,7 @@ static struct attribute *snbep_uncore_pcu_formats_attr[] = {
>  };
>
>  static struct uncore_event_desc snbep_uncore_imc_events[] = {
> -       INTEL_UNCORE_EVENT_DESC(clockticks,      "event=0xff,umask=0xff"),
> +       INTEL_UNCORE_EVENT_DESC(clockticks,      "event=0xff"),
>        INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x03"),
>        INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x0c"),
>        { /* end: all zeroes */ },
> @@ -616,7 +616,7 @@ static struct attribute_group nhm_uncore_format_group = {
>  };
>
>  static struct uncore_event_desc nhm_uncore_events[] = {
> -       INTEL_UNCORE_EVENT_DESC(clockticks,                "event=0xff,umask=0xff"),
> +       INTEL_UNCORE_EVENT_DESC(clockticks,                "event=0xff"),
>        INTEL_UNCORE_EVENT_DESC(qmc_writes_full_any,       "event=0x2f,umask=0x0f"),
>        INTEL_UNCORE_EVENT_DESC(qmc_normal_reads_any,      "event=0x2c,umask=0x0f"),
>        INTEL_UNCORE_EVENT_DESC(qhl_request_ioh_reads,     "event=0x20,umask=0x01"),
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> index 4d52db0..88498c7 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
> @@ -9,7 +9,7 @@
>
>  #define UNCORE_PMU_HRTIMER_INTERVAL    (60 * NSEC_PER_SEC)
>
> -#define UNCORE_FIXED_EVENT             0xffff
> +#define UNCORE_FIXED_EVENT             0xff
>  #define UNCORE_PMC_IDX_MAX_GENERIC     8
>  #define UNCORE_PMC_IDX_FIXED           UNCORE_PMC_IDX_MAX_GENERIC
>  #define UNCORE_PMC_IDX_MAX             (UNCORE_PMC_IDX_FIXED + 1)
> --
> 1.7.10.2
>
