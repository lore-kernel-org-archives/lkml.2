Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab0INGn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 02:43:57 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:41935 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab0INGn4 (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:7:1>);
	Tue, 14 Sep 2010 02:43:56 -0400
Message-Id: <4C8F35F10200007800015E5E@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 14 Sep 2010 07:44:33 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Chen Gong" <gong.chen@linux.intel.com>
Cc: <mingo@elte.hu>, <fenghua.yu@intel.com>, <tglx@linutronix.de>,
        <khali@linux-fr.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [lm-sensors] [PATCH] x86/hwmon: fix initialization of
	 coretemp
References: <4C8E16770200007800015ACC@vpn.id2.novell.com>
 <4C8F178F.2080306@linux.intel.com>
In-Reply-To: <4C8F178F.2080306@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.09.10 at 08:34, Chen Gong <gong.chen@linux.intel.com> wrote:
> 于 9/13/2010 6:17 PM, Jan Beulich 写道:
>> Using cpuid_eax() to determine feature availability on other than
>> the current CPU is invalid. And feature availability should also be
>> checked in the hotplug code path.
>>
>> Signed-off-by: Jan Beulich<jbeulich@novell.com>
>> Cc: Rudolf Marek<r.marek@assembler.cz>
>>
>> ---
>>   arch/x86/include/asm/cpufeature.h |    1 +
>>   arch/x86/kernel/cpu/scattered.c   |    1 +
>>   drivers/hwmon/coretemp.c          |   29 +++++++++++++----------------
>>   3 files changed, 15 insertions(+), 16 deletions(-)
>>
>> --- linux-2.6.36-rc4/arch/x86/include/asm/cpufeature.h	2010-09-13 
> 08:44:55.000000000 +0200
>> +++ 
> 2.6.36-rc4-x86-coretemp-feature-check/arch/x86/include/asm/cpufeature.h	20
> 10-09-01 09:18:17.000000000 +0200
>> @@ -168,6 +168,7 @@
>>   #define X86_FEATURE_XSAVEOPT	(7*32+ 4) /* Optimized Xsave */
>>   #define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
>>   #define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
>> +#define X86_FEATURE_DTS		(7*32+ 7) /* Digital Thermal Sensor */
> 
> Do we really need a new CPU flag ?

We don't strictly need one, but for one it parallels X86_FEATURE_PTS,
and it allows easy identification of the feature's availability from user
space.

Jan
