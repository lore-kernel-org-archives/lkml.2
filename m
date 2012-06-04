Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557Ab2FDNPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:15:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:17724 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab2FDNPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:15:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="160344851"
Message-ID: <4FCCB4DD.4060407@linux.intel.com>
Date: Mon, 04 Jun 2012 06:15:09 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Vladimir Davydov <vdavydov@parallels.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
In-Reply-To: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/2012 3:24 AM, Vladimir Davydov wrote:
> rq->cpuload strongly depends on cgroup hierarchy. For example, if hundreds of
> tasks are running inside cpu:/test cgroup, the sum of cpuload over all cpus
> won't exceed 1024 (by default). That makes the cpuidle menu governor take wrong
> decisions, which can negatively affect overall performance.

nr_running is the wrong answer... it is instantaneous, not longer term.
cpuidle wants a longer term, per cpu, notion of "busy", to use as proxy
for performance sensitivity.


