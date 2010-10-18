Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab0JRICU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 04:02:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:25545 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab0JRICS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 04:02:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,345,1283756400"; 
   d="scan'208";a="337241265"
From: "Ma, Ling" <ling.ma@intel.com>
To: "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 18 Oct 2010 16:01:13 +0800
Subject: RE: [PATCH V2 -tip] lib,x86_64: improve the performance of memcpy()
 for unaligned copy
Thread-Topic: [PATCH V2 -tip] lib,x86_64: improve the performance of
 memcpy() for unaligned copy
Thread-Index: ActumBOryPSVrRnfRkuCOEAzxNLDhQAAUYtQ
Message-ID: <C10D3FB0CD45994C8A51FEC1227CE22F15D77722D0@shsmsx502.ccr.corp.intel.com>
References: <4CAEC81C.1070108@cn.fujitsu.com>
 <C10D3FB0CD45994C8A51FEC1227CE22F15C916E769@shsmsx502.ccr.corp.intel.com>
 <4CAEDE0D.2040009@cn.fujitsu.com> <4CB62543.7000605@zytor.com>
 <C10D3FB0CD45994C8A51FEC1227CE22F15CC203E71@shsmsx502.ccr.corp.intel.com>
 <4CBBE7FB.2060303@cn.fujitsu.com>
 <C10D3FB0CD45994C8A51FEC1227CE22F15D77721FD@shsmsx502.ccr.corp.intel.com>
 <4CBBEA7F.7010604@cn.fujitsu.com>
 <C10D3FB0CD45994C8A51FEC1227CE22F15D777221E@shsmsx502.ccr.corp.intel.com>
 <4CBBFA7F.1010109@cn.fujitsu.com>
In-Reply-To: <4CBBFA7F.1010109@cn.fujitsu.com>
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




>> rep_good will cause memcpy jump to memcpy_c, so not run this patch,
>> we may continue to do further optimization on it later.

>Yes, but in fact, the performance of memcpy_c is not better on some micro-architecture(such as:
>Wolfdale-3M, ), especially in the unaligned cases, so we need do optimization for it, and I think
>the first step of optimization is optimizing the original code of memcpy().

As mentioned above , we will optimize further memcpy_c soon.
Two reasons : 
  1. movs instruction need long lantency to startup
  2. movs instruction is not good for unaligned case.
  
>> BTW the improvement is only from core2 shift register optimization,
>> but for most previous cpus shift register is very sensitive because of decode stage. 
>> I have test Atom, Opteron, and Nocona, new patch is still better.

>I think we can add a flag to make this improvement only valid for Core2 or other CPU like it,
>just like X86_FEATURE_REP_GOOD.

We should optimize core2 in memcpy_c function in future, I think.

Thanks
Ling


