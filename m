Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab1GAIMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:12:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:64333 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab1GAIMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:12:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,456,1304319600"; 
   d="scan'208";a="25102208"
From: "Ma, Ling" <ling.ma@intel.com>
To: "Ma, Ling" <ling.ma@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 1 Jul 2011 16:10:37 +0800
Subject: RE: [PATCH RFC] [x86] Optimize copy-page by reducing impact from HW
 prefetch
Thread-Topic: [PATCH RFC] [x86] Optimize copy-page by reducing impact from
 HW prefetch
Thread-Index: Acwxc9zXuTo3YQvYQpKzil1gi1OinwEGCmlAAI3KBfA=
Message-ID: <C10D3FB0CD45994C8A51FEC1227CE22F27124E9914@shsmsx502.ccr.corp.intel.com>
References: <1308351117-32452-1-git-send-email-ling.ma@intel.com>
 <m2fwn13a3u.fsf@firstfloor.org> <20110623070448.GA25707@elte.hu> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forget to append experiment data:

1. We copy 4096 bytes for 32 times on snb, and extract minimum execution time 
On hot cache case: 
  Copy_page          copy_page_c 
  482 cycles          350 cycles

2. the same routine with hot-caches, but before each execution we copy 512k data to push original data out of L1 &L2.
On cold cache case:
  copy_page(with prefetch)    copy_page(without prefetch)      copy_page_c
   853~873 cycles                  1037~1051 cycles            959~976 cycles 

Thanks
Ling

> -----Original Message-----
> From: Ma, Ling
> Sent: Tuesday, June 28, 2011 11:24 PM
> To: 'Ingo Molnar'; Andi Kleen
> Cc: hpa@zytor.com; tglx@linutronix.de; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH RFC] [x86] Optimize copy-page by reducing impact
> from HW prefetch
> 
> Hi Ingo
> 
> > Ling, mind double checking which one is the faster/better one on SNB,
> > in cold-cache and hot-cache situations, copy_page or copy_page_c?
> Copy_page_c
> on hot-cache copy_page_c on SNB combines data to 128bit (processor
> limit 128bit/cycle for write) after startup latency
> so it is faster than copy_page which provides 64bit/cycle for write.
> 
> on cold-cache copy_page_c doesn't use prefetch, which uses prfetch
> according to copy size,
> so copy_page function is better.
> 
> Thanks
> Ling

