Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab2JPEnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:43:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56750 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab2JPEna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:43:30 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Date: Tue, 16 Oct 2012 13:43:04 +0900 (JST)
Message-Id: <20121016.134304.86248639.d.hatayama@jp.fujitsu.com>
To: fenghua.yu@intel.com
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        asit.k.mallick@intel.com, tony.luck@intel.com, arjan@linux.intel.com,
        suresh.b.siddha@intel.com, len.brown@intel.com,
        srivatsa.bhat@linux.vnet.ibm.com, rdunlap@xenotime.net,
        gong.chen@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v9 08/12] x86, hotplug: Wake up CPU0 via NMI instead of
 INIT, SIPI, SIPI
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <1350058189-6769-9-git-send-email-fenghua.yu@intel.com>
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
	<1350058189-6769-9-git-send-email-fenghua.yu@intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v9 08/12] x86, hotplug: Wake up CPU0 via NMI instead of INIT, SIPI, SIPI
Date: Fri, 12 Oct 2012 09:09:45 -0700

<cut>

> @@ -1037,6 +1101,8 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>  	 */
>  	setup_local_APIC();
>  
> +	cpu0_logical_apicid = GET_APIC_LOGICAL_ID(apic_read(APIC_LDR));
> +

In x2apic mode, logical apicid occupies a whole 32-bit length of LDR,
but GET_APIC_LOGICAL_ID returns high 31-24 bits only, and this is only
for xapic mode.

Thanks.
HATAYAMA, Daisuke

