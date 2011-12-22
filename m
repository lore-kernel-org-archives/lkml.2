Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1LVABr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:01:47 -0500
Received: from mga03.intel.com ([143.182.124.21]:23647 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab1LVABo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:01:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="49574441"
Date: Wed, 21 Dec 2011 16:01:42 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Renninger <trenn@suse.de>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, kay.sievers@vrf.org,
        kay.sievers@vrfy.org
Subject: Re: [PATCH 7/8] cpufreq: Add support for x86 cpuinfo auto loading
 v3
Message-ID: <20111222000142.GA10955@alboin.amr.corp.intel.com>
References: <1324338394-4670-1-git-send-email-andi@firstfloor.org>
 <1324338394-4670-8-git-send-email-andi@firstfloor.org>
 <201112211203.26153.trenn@suse.de>
 <20111221201227.GA9262@alboin.amr.corp.intel.com>
 <4EF23E41.40608@zytor.com>
 <20111221213009.GA2568@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221213009.GA2568@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A synthetic one is pointless, because you'd just be duplicating something
> similar to the above in generic code that would need updating for every new stepping.

powernow-k8 uses two mechanisms: family/models and on newer CPUs like
Fam15 a CPUID bit.  Just not in the standard leaves. This would
not need to be updated.

 } else { /* must be a HW Pstate capable processor */
                cpuid(CPUID_FREQ_VOLT_CAPABILITIES, &eax, &ebx, &ecx, &edx);
                if ((edx & USE_HW_PSTATE) == USE_HW_PSTATE)
                        cpu_family = CPU_HW_PSTATE;
                else
                        return;
}

-Andi
