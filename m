Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab1ELGHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 02:07:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36582 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab1ELGHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 02:07:09 -0400
Message-ID: <4DCB78ED.9040409@zytor.com>
Date: Wed, 11 May 2011 23:06:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86, cpu: Enable/disable SMEP
References: <1305141480-843-1-git-send-email-fenghua.yu@intel.com>	<1305141480-843-4-git-send-email-fenghua.yu@intel.com> <m2k4dwj24x.fsf@firstfloor.org>
In-Reply-To: <m2k4dwj24x.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2011 03:36 PM, Andi Kleen wrote:
> "Fenghua Yu"<fenghua.yu@intel.com>  writes:
>
>> +static int disable_smep;
>
> If you add a __initdata here the whole thing will completely disappear
> after boot.
>
>> @@ -867,6 +886,8 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
>>   	/* Init Machine Check Exception if available. */
>>   	mcheck_cpu_init(c);
>>
>> +	setup_smep(c);
>
> My feeling is you're setting this too late. In theory there could be
> early overflows. Better use a early_param and set it as early
> as possible, directly after the cpuid flags are set up in early
> initialization.
>
> -Andi

SMEP only matters if we can into userspace code, so I *think* the above 
should be okay.  However, the most logical place would be to enable it 
in the same place(s) where we enable NX.

	-hpa
