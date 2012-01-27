Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2A0FDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 00:03:38 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:41372 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2A0FDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 00:03:35 -0500
Message-ID: <4F22301B.5090804@linux.vnet.ibm.com>
Date: Fri, 27 Jan 2012 10:33:23 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@infradead.org, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu
Subject: Re: [PATCH 02/13] perf_events: add Intel LBR MSR definitions (v3)
References: <1326127761-2723-1-git-send-email-eranian@google.com> <1326127761-2723-3-git-send-email-eranian@google.com>
In-Reply-To: <1326127761-2723-3-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12012705-8256-0000-0000-0000010914E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 January 2012 10:19 PM, Stephane Eranian wrote:
> This patch adds the LBR definitions for NHM/WSM/SNB and Core.
> It also adds the definitions for the architected LBR MSR:
> LBR_SELECT, LBRT_TOS.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
  Reviewed   by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/msr-index.h           |    7 +++++++
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |   18 +++++++++---------
>  2 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index a6962d9..ccb8059 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -56,6 +56,13 @@
>  #define MSR_OFFCORE_RSP_0		0x000001a6
>  #define MSR_OFFCORE_RSP_1		0x000001a7
> 
> +#define MSR_LBR_SELECT			0x000001c8
> +#define MSR_LBR_TOS			0x000001c9
> +#define MSR_LBR_NHM_FROM		0x00000680
> +#define MSR_LBR_NHM_TO			0x000006c0
> +#define MSR_LBR_CORE_FROM		0x00000040
> +#define MSR_LBR_CORE_TO			0x00000060
> +
>  #define MSR_IA32_PEBS_ENABLE		0x000003f1
>  #define MSR_IA32_DS_AREA		0x00000600
>  #define MSR_IA32_PERF_CAPABILITIES	0x00000345
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> index c3f8100..e14431f 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -205,23 +205,23 @@ void intel_pmu_lbr_read(void)
>  void intel_pmu_lbr_init_core(void)
>  {
>  	x86_pmu.lbr_nr     = 4;
> -	x86_pmu.lbr_tos    = 0x01c9;
> -	x86_pmu.lbr_from   = 0x40;
> -	x86_pmu.lbr_to     = 0x60;
> +	x86_pmu.lbr_tos    = MSR_LBR_TOS;
> +	x86_pmu.lbr_from   = MSR_LBR_CORE_FROM;
> +	x86_pmu.lbr_to     = MSR_LBR_CORE_TO;
>  }
> 
>  void intel_pmu_lbr_init_nhm(void)
>  {
>  	x86_pmu.lbr_nr     = 16;
> -	x86_pmu.lbr_tos    = 0x01c9;
> -	x86_pmu.lbr_from   = 0x680;
> -	x86_pmu.lbr_to     = 0x6c0;
> +	x86_pmu.lbr_tos    = MSR_LBR_TOS;
> +	x86_pmu.lbr_from   = MSR_LBR_NHM_FROM;
> +	x86_pmu.lbr_to     = MSR_LBR_NHM_TO;
>  }
> 
>  void intel_pmu_lbr_init_atom(void)
>  {
>  	x86_pmu.lbr_nr	   = 8;
> -	x86_pmu.lbr_tos    = 0x01c9;
> -	x86_pmu.lbr_from   = 0x40;
> -	x86_pmu.lbr_to     = 0x60;
> +	x86_pmu.lbr_tos    = MSR_LBR_TOS;
> +	x86_pmu.lbr_from   = MSR_LBR_CORE_FROM;
> +	x86_pmu.lbr_to     = MSR_LBR_CORE_TO;
>  }


-- 
Linux Technology Centre
IBM Systems and Technology Group
Bangalore India

