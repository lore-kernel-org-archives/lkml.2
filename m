Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031126Ab1EXB0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:26:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18577 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab1EXB0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:26:50 -0400
Message-ID: <4DDB093F.2060601@kernel.org>
Date: Mon, 23 May 2011 18:26:23 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage based
 on semi-formal proof"
References: <4DD6F64C.3030402@kernel.org> <20110520234923.GQ2366@linux.vnet.ibm.com> <4DD70120.9090801@kernel.org> <20110521131844.GE2271@linux.vnet.ibm.com> <20110521140845.GA12157@linux.vnet.ibm.com> <4DDAC01E.7050602@kernel.org> <20110523212530.GF7428@linux.vnet.ibm.com> <4DDAD934.9010603@kernel.org> <4DDAE5FA.2030303@kernel.org> <4DDAE6A5.6060701@kernel.org> <20110524011824.GL7428@linux.vnet.ibm.com>
In-Reply-To: <20110524011824.GL7428@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DDB0947.009A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2011 06:18 PM, Paul E. McKenney wrote:

> OK, so it looks like I need to get this out of the way in order to track
> down the delays.  Or does reverting PeterZ's patch get you a stable
> system, but with the longish delays in memory_dev_init()?  If the latter,
> it might be more productive to handle the two problems separately.
> 
> For whatever it is worth, I do see about 5% increase in grace-period
> duration when switching to kthreads.  This is acceptable -- your
> 30x increase clearly is completely unacceptable and must be fixed.
> Other than that, the main thing that affects grace period duration is
> the setting of CONFIG_HZ -- the smaller the HZ value, the longer the
> grace-period duration.

for my 1024g system when memory hotadd is enabled in kernel config:
1. current linus tree + tip tree:  memory_dev_init will take about 100s.
2. current linus tree + tip tree + your tree - Peterz patch: 
   a. on fedora 14 gcc: will cost about 4s: like old times
   b. on opensuse 11.3 gcc: will cost about 10s.

Thanks

Yinghai Lu

