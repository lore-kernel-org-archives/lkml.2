Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748Ab1F1P1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:27:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:59253 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698Ab1F1PZV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:25:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,437,1304319600"; 
   d="scan'208";a="19784162"
From: "Ma, Ling" <ling.ma@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jun 2011 23:23:52 +0800
Subject: RE: [PATCH RFC] [x86] Optimize copy-page by reducing impact from HW
 prefetch
Thread-Topic: [PATCH RFC] [x86] Optimize copy-page by reducing impact from
 HW prefetch
Thread-Index: Acwxc9zXuTo3YQvYQpKzil1gi1OinwEGCmlA
Message-ID: <C10D3FB0CD45994C8A51FEC1227CE22F27050B5318@shsmsx502.ccr.corp.intel.com>
References: <1308351117-32452-1-git-send-email-ling.ma@intel.com>
 <m2fwn13a3u.fsf@firstfloor.org> <20110623070448.GA25707@elte.hu>
In-Reply-To: <20110623070448.GA25707@elte.hu>
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

Hi Ingo
 
> Ling, mind double checking which one is the faster/better one on SNB,
> in cold-cache and hot-cache situations, copy_page or copy_page_c?
Copy_page_c 
on hot-cache copy_page_c on SNB combines data to 128bit (processor limit 128bit/cycle for write) after startup latency
so it is faster than copy_page which provides 64bit/cycle for write.

on cold-cache copy_page_c doesn't use prefetch, which uses prfetch according to copy size,
so copy_page function is better. 

Thanks
Ling

