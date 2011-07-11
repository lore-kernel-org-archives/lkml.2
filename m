Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab1GKIuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 04:50:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:39102 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757439Ab1GKIuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 04:50:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,514,1304319600"; 
   d="scan'208";a="28829231"
Subject: Re: [PATCH 3/4] perf, x86: Add Intel SandyBridge pricise store
 support
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1310373148.13309.26.camel@twins>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	 <1309766525-14089-4-git-send-email-ming.m.lin@intel.com>
	 <1310373148.13309.26.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 16:57:13 +0800
Message-ID: <1310374633.18875.218.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-11 at 16:32 +0800, Peter Zijlstra wrote:
> On Mon, 2011-07-04 at 08:02 +0000, Lin Ming wrote:
> > Implements Intel memory store event for SandyBridge.
> > 
> > $ perf mem -t store record make -j8
> 
> 
> I was just looking through the Intel SDM, and stumbled upon:
> 
> C0H	01H	INST_RETIRED.PREC_DIST
> 
> Precise instruction retired event
> with HW to reduce effect of PEBS
> shadow in IP distribution PMC1 only; 
> Must quiesce other PMCs.
> ^^^^^^^^^^^^^^^^^^^^^^^^
> 
> WTF!? Are they real? The implementation as provided by you doesn't do
> that (quite understandably), but please check with the hardware folks.

This is Precise Distribution of Instructions Retired (PDIR), which is
not related to Precise Store.


