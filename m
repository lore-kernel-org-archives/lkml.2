Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab2EDFsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 01:48:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:16689 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab2EDFsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 01:48:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="96269570"
Message-ID: <4FA36D3F.6000608@intel.com>
Date: Fri, 04 May 2012 13:46:39 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "Ren, Yongjie" <yongjie.ren@intel.com>
CC: "Kleen, Andi" <andi.kleen@intel.com>,
        "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
        "akataria@vmware.com" <akataria@vmware.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "riel@redhat.com" <riel@redhat.com>, "luto@mit.edu" <luto@mit.edu>,
        "avi@redhat.com" <avi@redhat.com>, "Brown, Len" <len.brown@intel.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "borislav.petkov@amd.com" <borislav.petkov@amd.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>, "cpw@sgi.com" <cpw@sgi.com>,
        "steiner@sgi.com" <steiner@sgi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86/flush_tlb: try flush_tlb_single one by one in
 flush_tlb_range
References: <1335603099-2624-1-git-send-email-alex.shi@intel.com> <1335603099-2624-3-git-send-email-alex.shi@intel.com> <1B4B44D9196EFF41AE41FDA404FC0A100AC423@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <1B4B44D9196EFF41AE41FDA404FC0A100AC423@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 10:24 AM, Ren, Yongjie wrote:

>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>> ---
>>  arch/x86/include/asm/paravirt.h       |    5 +-
>>  arch/x86/include/asm/paravirt_types.h |    3 +-
>>  arch/x86/include/asm/tlbflush.h       |   19 +++----
>>  arch/x86/include/asm/uv/uv.h          |    5 +-
>>  arch/x86/mm/tlb.c                     |   97
>> +++++++++++++++++++++++++++------
>>  arch/x86/platform/uv/tlb_uv.c         |    6 +-
>>  arch/x86/xen/mmu.c                    |    9 ++--
>>  include/trace/events/xen.h            |   12 +++--
>>  8 files changed, 113 insertions(+), 43 deletions(-)
> 
> As the patch series touched some Xen virtualization code, I just did some simple test on Xen and KVM.
> It seems these patches work fine on Xen/KVM virtual side.
> I started an SMP PV guest and an SMP HVM guest on Xen, and an SMP guest on KVM.
> 
> Best Regards,
>      Yongjie (Jay)
> 



Thanks a lot! Yongjie.
