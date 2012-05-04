Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab2EDCYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 22:24:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:50832 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810Ab2EDCYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 22:24:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="96222603"
From: "Ren, Yongjie" <yongjie.ren@intel.com>
To: "Shi, Alex" <alex.shi@intel.com>, "Kleen, Andi" <andi.kleen@intel.com>,
        "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
        "akataria@vmware.com" <akataria@vmware.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>
CC: "riel@redhat.com" <riel@redhat.com>, "luto@mit.edu" <luto@mit.edu>,
        "avi@redhat.com" <avi@redhat.com>, "Brown, Len" <len.brown@intel.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "borislav.petkov@amd.com" <borislav.petkov@amd.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>, "cpw@sgi.com" <cpw@sgi.com>,
        "steiner@sgi.com" <steiner@sgi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] x86/flush_tlb: try flush_tlb_single one by one in
 flush_tlb_range
Thread-Topic: [PATCH 2/3] x86/flush_tlb: try flush_tlb_single one by one in
 flush_tlb_range
Thread-Index: AQHNJRxX0OEfnjcKCEqtRYUJcj3uBZa47ing
Date: Fri, 4 May 2012 02:24:07 +0000
Message-ID: <1B4B44D9196EFF41AE41FDA404FC0A100AC423@SHSMSX101.ccr.corp.intel.com>
References: <1335603099-2624-1-git-send-email-alex.shi@intel.com>
 <1335603099-2624-3-git-send-email-alex.shi@intel.com>
In-Reply-To: <1335603099-2624-3-git-send-email-alex.shi@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  arch/x86/include/asm/paravirt.h       |    5 +-
>  arch/x86/include/asm/paravirt_types.h |    3 +-
>  arch/x86/include/asm/tlbflush.h       |   19 +++----
>  arch/x86/include/asm/uv/uv.h          |    5 +-
>  arch/x86/mm/tlb.c                     |   97
> +++++++++++++++++++++++++++------
>  arch/x86/platform/uv/tlb_uv.c         |    6 +-
>  arch/x86/xen/mmu.c                    |    9 ++--
>  include/trace/events/xen.h            |   12 +++--
>  8 files changed, 113 insertions(+), 43 deletions(-)

As the patch series touched some Xen virtualization code, I just did some simple test on Xen and KVM.
It seems these patches work fine on Xen/KVM virtual side.
I started an SMP PV guest and an SMP HVM guest on Xen, and an SMP guest on KVM.

Best Regards,
     Yongjie (Jay)

