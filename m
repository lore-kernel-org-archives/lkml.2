Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab0JLAvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 20:51:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:58602 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358Ab0JLAvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 20:51:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,317,1283756400"; 
   d="scan'208";a="334906794"
Subject: Re: [PATCH -v3 3/6] x86, NMI, Rewrite NMI handler
From: Huang Ying <ying.huang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <1286813635.2336.617.camel@twins>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
	 <1286606987-19879-3-git-send-email-ying.huang@intel.com>
	 <1286813635.2336.617.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 08:50:50 +0800
Message-ID: <1286844650.7768.137.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 00:13 +0800, Peter Zijlstra wrote:
> On Sat, 2010-10-09 at 14:49 +0800, Huang Ying wrote:
> > notify_die(DIE_NMI_IPI);
> > notify_die(DIE_NMI);
> > /* process io port 0x61 */
> > nmi_watchdog_touch();
> > unknown_nmi(); 
> 
> Why keep NMI_IPI? What the heck is it for?

DIE_NMI_IPI is used for CPU-specific or CPU-local NMIs, such as perf
NMI. While DIE_NMI is used for non-CPU-specific or global NMIs, such as
NMI notification from source bridge.

The order between these two is important. So we use two die value to
enforce the order.

> I'd like to see:
> 
>  DIE_NMI
>  DIE_NMI_UNKNOWN
> 
> In DIE_NMI we walk the chain and deal with NMIs, in DIE_NMI_UNKNOWN we
> try to consume extra NMIs where possible (like the much discussed extra
> PMU interrupts).

Best Regards,
Huang Ying


