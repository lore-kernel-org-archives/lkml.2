Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab0INGe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 02:34:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:8782 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab0INGe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 02:34:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,362,1280732400"; 
   d="scan'208";a="324258027"
Message-ID: <4C8F178F.2080306@linux.intel.com>
Date: Tue, 14 Sep 2010 14:34:55 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: fenghua.yu@intel.com, khali@linux-fr.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de
Subject: Re: [lm-sensors] [PATCH] x86/hwmon: fix initialization of coretemp
References: <4C8E16770200007800015ACC@vpn.id2.novell.com>
In-Reply-To: <4C8E16770200007800015ACC@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 9/13/2010 6:17 PM, Jan Beulich 写道:
> Using cpuid_eax() to determine feature availability on other than
> the current CPU is invalid. And feature availability should also be
> checked in the hotplug code path.
>
> Signed-off-by: Jan Beulich<jbeulich@novell.com>
> Cc: Rudolf Marek<r.marek@assembler.cz>
>
> ---
>   arch/x86/include/asm/cpufeature.h |    1 +
>   arch/x86/kernel/cpu/scattered.c   |    1 +
>   drivers/hwmon/coretemp.c          |   29 +++++++++++++----------------
>   3 files changed, 15 insertions(+), 16 deletions(-)
>
> --- linux-2.6.36-rc4/arch/x86/include/asm/cpufeature.h	2010-09-13 08:44:55.000000000 +0200
> +++ 2.6.36-rc4-x86-coretemp-feature-check/arch/x86/include/asm/cpufeature.h	2010-09-01 09:18:17.000000000 +0200
> @@ -168,6 +168,7 @@
>   #define X86_FEATURE_XSAVEOPT	(7*32+ 4) /* Optimized Xsave */
>   #define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
>   #define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
> +#define X86_FEATURE_DTS		(7*32+ 7) /* Digital Thermal Sensor */

Do we really need a new CPU flag ?
