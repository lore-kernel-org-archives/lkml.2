Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab0DHIKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 04:10:04 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59654 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab0DHIJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 04:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=INizkrOAVLEOnx64cfJTTHMtbRVxzU3VFmg1YGM3rzHlbJV6jEuln9T1Z+VmSBDByi
         oYMRD/PRL39c54e4E/DU7HtQpCSrMsqFgftHsQP3z4M8OMQl6Bjl92F2mMiTvjFT6hDX
         Pp4+IKDRbDoEy2CCMvfTDvylr8TQkHdd0g67Y=
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, netdev <netdev@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1270713272.2215.6.camel@edumazet-laptop>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
	 <alpine.DEB.2.00.1003250942080.2670@router.home>
	 <1269570902.9614.92.camel@alexs-hp.sh.intel.com>
	 <1270114166.2078.107.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004011050340.16531@router.home>
	 <1270195589.2078.116.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004050853300.23149@router.home>
	 <i2z84144f021004051030k7ff5190cyc083aa12c552dfac@mail.gmail.com>
	 <4BBA8DF9.8010409@kernel.org>
	 <1270542497.2078.123.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004061033330.18750@router.home>
	 <alpine.DEB.2.00.1004061552500.19151@router.home>
	 <1270591841.2091.170.camel@edumazet-laptop>
	 <1270607668.2078.259.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004071130260.13261@router.home>
	 <4BBCB7B7.4040901@cs.helsinki.fi> <4BBCB868.2000705@cs.helsinki.fi>
	 <alpine.DEB.2.00.1004071319320.16159@router.home>
	 <1270665484.8141.47.camel@edumazet-laptop>
	 <1270688747.2078.383.camel@ymzhang.sh.intel.com>
	 <1270702774.8141.49.camel@edumazet-laptop>
	 <1270705153.8141.58.camel@edumazet-laptop>
	 <1270710019.2215.4.camel@edumazet-laptop>
	 <1270713290.2078.402.camel@ymzhang.sh.intel.com>
	 <1270713272.2215.6.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 10:09:55 +0200
Message-ID: <1270714195.2215.14.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 08 avril 2010 à 09:54 +0200, Eric Dumazet a écrit :
> Le jeudi 08 avril 2010 à 15:54 +0800, Zhang, Yanmin a écrit :
> 
> > If there are 2 nodes in the machine, processes on node 0 will contact MCH of
> > node 1 to access memory of node 1. I suspect the MCH of node 1 might enter
> > a power-saving mode when all the cpus of node 1 are free. So the transactions
> > from MCH 1 to MCH 0 has a larger latency.
> > 
> 
> Hmm, thanks for the hint, I will investigate this.

Oh well, 

perf timechart record &

Instant crash

Call Trace:
 perf_trace_sched_switch+0xd5/0x120
 schedule+0x6b5/0x860
 retint_careful+0xd/0x21
 
RIP ffffffff81010955 perf_arch_fetch_caller_regs+0x15/0x40
CR2: 00000000d21f1422


