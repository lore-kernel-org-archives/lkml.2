Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab1LUJos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 04:44:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:52811 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab1LUJoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 04:44:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="89898526"
Message-ID: <4EF1AA8A.8060304@linux.intel.com>
Date: Wed, 21 Dec 2011 10:44:42 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 0/3] coupled cpuidle state support
References: <1324426147-16735-1-git-send-email-ccross@android.com> <4EF1A0B4.5080307@linux.intel.com> <CAMbhsRRP7s9xsHqxhb=iMfHAJFcqAea-6CDORZS34RCPNo+UWw@mail.gmail.com>
In-Reply-To: <CAMbhsRRP7s9xsHqxhb=iMfHAJFcqAea-6CDORZS34RCPNo+UWw@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 10:40 AM, Colin Cross wrote:

>> this smells fundamentally racey to me; you can get an interrupt one
>> cycle after you think you're done, but before the last guy enters WFI...
>>
>> how do you solve that issue ?
> 
> All the cpus have interrupts off when they increment the counter, so
> they cannot receive an interrupt.  If an interrupt is pending on one
> of those cpus, it will be handled later when WFI aborts due to the
> pending interrupt.

... but this leads to cases where you're aborting before other cpus are
entering..... so your "last guy in" doesn't really work, since while cpu
0 thinks it's the last guy, cpu 1 is already on the way out/out
already...  (heck it might already be going back to sleep if your idle
code can run fast, like in the size of a cache miss)
