Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2FDNTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:19:22 -0400
Received: from relay.parallels.com ([195.214.232.42]:51159 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760416Ab2FDNTU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:19:20 -0400
From: Vladimir Davydov <VDavydov@parallels.com>
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 4 Jun 2012 17:19:08 +0400
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
Thread-Topic: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
Thread-Index: Ac1CVKItH9QK1QugQ3KhVd3IYUN4vQ==
Message-ID: <9511B40F-7F71-4A99-87B8-4CD88C83FE4E@parallels.com>
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
 <4FCCB4DD.4060407@linux.intel.com>
In-Reply-To: <4FCCB4DD.4060407@linux.intel.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, ru-RU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 4, 2012, at 5:15 PM, "Arjan van de Ven" <arjan@linux.intel.com> wrote:

> On 6/4/2012 3:24 AM, Vladimir Davydov wrote:
>> rq->cpuload strongly depends on cgroup hierarchy. For example, if hundreds of
>> tasks are running inside cpu:/test cgroup, the sum of cpuload over all cpus
>> won't exceed 1024 (by default). That makes the cpuidle menu governor take wrong
>> decisions, which can negatively affect overall performance.
> 
> nr_running is the wrong answer... it is instantaneous, not longer term.
> cpuidle wants a longer term, per cpu, notion of "busy", to use as proxy
> for performance sensitivity.
> 
> 

I use not the instantaneous nr_running, but nr_running last seen in update_cpu_load() where cpuload[0], which is currently used by cpuidle, is updated.

