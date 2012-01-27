Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab2A0GPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:15:14 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:38903 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2A0GPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:15:12 -0500
Message-ID: <4F2240DD.9050006@linux.vnet.ibm.com>
Date: Fri, 27 Jan 2012 11:44:53 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@infradead.org, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu
Subject: Re: [PATCH 07/13] perf_events: implement PERF_SAMPLE_BRANCH for Intel
 X86 (v3)
References: <1326127761-2723-1-git-send-email-eranian@google.com> <1326127761-2723-8-git-send-email-eranian@google.com>
In-Reply-To: <1326127761-2723-8-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
x-cbid: 12012706-8256-0000-0000-00000109405B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 January 2012 10:19 PM, Stephane Eranian wrote:
> This patch implements PERF_SAMPLE_BRANCH support for Intel
> X86 processors. It connects PERF_SAMPLE_BRANCH to the actual LBR.
> 
> The patch adds the hooks in the PMU irq handler to save the LBR
> on counter overflow for both regular and PEBS modes.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c     |   35 +++++++++++++
>  arch/x86/kernel/cpu/perf_event_intel_ds.c  |   10 ++--
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |   73 +++++++++++++++++++++++++++-
>  include/linux/perf_event.h                 |    3 +
>  4 files changed, 113 insertions(+), 8 deletions(-)
> 
This patch FAILs to compile independently because of the function
'intel_pmu_setup_lbr_filter' which is defined arch/x86/kernel/
cpu/perf_event_intel_lbr.c but used in arch/x86/kernel/cpu
/perf_event_intel.c without making the prototype update in
the header arch/x86/kernel/cpu/perf_event.h. Though [PATCH 8/13]
rectifies the problem, [PATCH 7/13] fails to compile independently.

arch/x86/kernel/cpu/perf_event_intel_lbr.c:291: warning: ‘intel_pmu_setup_lbr_filter’ defined but not used
  CC      arch/x86/kernel/cpu/perf_event_intel_ds.o
  CC      arch/x86/kernel/cpu/perf_event_intel.o
arch/x86/kernel/cpu/perf_event_intel.c: In function ‘intel_pmu_hw_config’:
arch/x86/kernel/cpu/perf_event_intel.c:1342: error: implicit declaration of function ‘intel_pmu_setup_lbr_filter’
make[3]: *** [arch/x86/kernel/cpu/perf_event_intel.o] Error 1
make[2]: *** [arch/x86/kernel/cpu] Error 2
make[1]: *** [arch/x86/kernel] Error 2
make: *** [arch/x86] Error 2

-- 
Linux Technology Centre
IBM Systems and Technology Group
Bangalore India

