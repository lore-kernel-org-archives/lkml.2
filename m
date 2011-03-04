Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab1CDJGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 04:06:50 -0500
Received: from server103.greatnet.de ([83.133.97.6]:44883 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab1CDJGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:06:46 -0500
Message-ID: <4D70ABA2.8090004@nachtwindheim.de>
Date: Fri, 04 Mar 2011 10:06:42 +0100
From: Henrik Kretzschmar <henne@nachtwindheim.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] x86: fix section of a disable_apic_timer
References: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de> <1299182701-8591-7-git-send-email-henne@nachtwindheim.de> <4D7005B1.4020008@gmail.com>
In-Reply-To: <4D7005B1.4020008@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.03.2011 22:18, schrieb Cyrill Gorcunov:
> On 03/03/2011 11:05 PM, Henrik Kretzschmar wrote:
>> This variable placed better into section .init.data,
>> since its only accessed by __init code.
>>
>> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
>> ---
>>  arch/x86/kernel/apic/apic.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
>> index 64efb2d..dab58b6 100644
>> --- a/arch/x86/kernel/apic/apic.c
>> +++ b/arch/x86/kernel/apic/apic.c
>> @@ -163,7 +163,7 @@ early_param("nox2apic", setup_nox2apic);
>>  unsigned long mp_lapic_addr;
>>  int disable_apic;
>>  /* Disable local APIC timer from the kernel commandline or via dmi quirk */
>> -static int disable_apic_timer __cpuinitdata;
>> +static int disable_apic_timer __initdata = 0;
>>  /* Local APIC timer works in C2 */
>>  int local_apic_timer_c2_ok;
>>  EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
> 
> Good to me, though I don't get why we need 0 here.
> 

I wanted to help gcc, but some tests showed me that gcc is much cleverer than I thought.
So I verified that you are right and I'll change that gladly.





