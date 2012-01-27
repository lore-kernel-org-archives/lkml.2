Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab2A0Fn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 00:43:59 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:55729 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2A0Fn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 00:43:58 -0500
Message-ID: <4F223996.2080708@linux.vnet.ibm.com>
Date: Fri, 27 Jan 2012 11:13:50 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@infradead.org, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu
Subject: Re: [PATCH 06/13] perf_events: disable LBR support for older Intel
 Atom processors (v3)
References: <1326127761-2723-1-git-send-email-eranian@google.com> <1326127761-2723-7-git-send-email-eranian@google.com>
In-Reply-To: <1326127761-2723-7-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12012705-9574-0000-0000-0000011FECB7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 January 2012 10:19 PM, Stephane Eranian wrote:
> The patch adds a restriction for Intel Atom LBR support. Only
> steppings 10 (PineView) and more recent are supported. Older models,
> do not have a functional LBR. Their LBR does not freeze on PMU interrupt
> which makes LBR unusable in the context of perf_events.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
  Reviewed-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> index 8a1eb6c..e2b7094 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -313,6 +313,16 @@ void intel_pmu_lbr_init_snb(void)
>  /* atom */
>  void intel_pmu_lbr_init_atom(void)
>  {
> +	/*
> +	 * only models starting at stepping 10 seems
> +	 * to have an operational LBR which can freeze
> +	 * on PMU interrupt
> +	 */
> +	if (boot_cpu_data.x86_mask < 10) {
> +		pr_cont("LBR disabled due to erratum");
> +		return;
> +	}
> +
>  	x86_pmu.lbr_nr	   = 8;
>  	x86_pmu.lbr_tos    = MSR_LBR_TOS;
>  	x86_pmu.lbr_from   = MSR_LBR_CORE_FROM;


-- 
Linux Technology Centre
IBM Systems and Technology Group
Bangalore India

