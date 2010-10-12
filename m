Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab0JLGhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 02:37:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:64845 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab0JLGha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 02:37:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,319,1283756400"; 
   d="scan'208";a="563043393"
Subject: Re: [PATCH -v3 3/6] x86, NMI, Rewrite NMI handler
From: Huang Ying <ying.huang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <1286865071.2336.1478.camel@twins>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
	 <1286606987-19879-3-git-send-email-ying.huang@intel.com>
	 <1286813635.2336.617.camel@twins>  <1286844650.7768.137.camel@yhuang-dev>
	 <1286863479.2336.1451.camel@twins>  <1286864080.7768.179.camel@yhuang-dev>
	 <1286865071.2336.1478.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 14:37:27 +0800
Message-ID: <1286865447.7768.184.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 14:31 +0800, Peter Zijlstra wrote:
> On Tue, 2010-10-12 at 14:14 +0800, Huang Ying wrote:
> > On Tue, 2010-10-12 at 14:04 +0800, Peter Zijlstra wrote:
> > > On Tue, 2010-10-12 at 08:50 +0800, Huang Ying wrote:
> > > > On Tue, 2010-10-12 at 00:13 +0800, Peter Zijlstra wrote:
> > > > > On Sat, 2010-10-09 at 14:49 +0800, Huang Ying wrote:
> > > > > > notify_die(DIE_NMI_IPI);
> > > > > > notify_die(DIE_NMI);
> > > > > > /* process io port 0x61 */
> > > > > > nmi_watchdog_touch();
> > > > > > unknown_nmi(); 
> > > > > 
> > > > > Why keep NMI_IPI? What the heck is it for?
> > > > 
> > > > DIE_NMI_IPI is used for CPU-specific or CPU-local NMIs, such as perf
> > > > NMI. While DIE_NMI is used for non-CPU-specific or global NMIs, such as
> > > > NMI notification from source bridge.
> > > > 
> > > > The order between these two is important. So we use two die value to
> > > > enforce the order.
> > > 
> > > But you can't know about that, there is no reason field to distinguish
> > > between these cases, so you might as well fold it into a single notifier
> > > chain and be done with it.
> > 
> > NMI users know that. Such as perf uses CPU-specific NMI, while APEI GHES
> > uses non-CPU-specific NMI. Different users expect different die values,
> > such as perf expects DIE_NMI_IPI, while APEI GHES expects DIE_NMI, so
> > that perf can be checked before APEI GHES.
> 
> GAAHHH, so why can't they live on a single notifier list? Its got
> priorities to deal with that?

It is possible to use priority to deal with the order. I just think two
die_value make order more explicit.

Best Regards,
Huang Ying


