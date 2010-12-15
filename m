Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab0LOWza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:55:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54413 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579Ab0LOWz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:55:27 -0500
Message-ID: <4D094703.7080701@zytor.com>
Date: Wed, 15 Dec 2010 14:53:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nikanth Karthikesan <knikanth@suse.de>,
        David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [PATCH] x86, acpi: Handle all SRAT cpu entries even have cpu
 num limitation
References: <20101111100628.GA24728@localhost> <1289478978.2084.74.camel@laptop> <20101111124015.GA9706@localhost> <1289480656.2084.80.camel@laptop> <20101113084018.GA23098@localhost> <1289644224.2084.521.camel@laptop> <20101113120030.GA31517@localhost> <1289653078.2084.675.camel@laptop> <20101113131042.GA5522@localhost> <4CDEE314.6090107@kernel.org> <20101113235746.GA9458@localhost> <4CDF3DA1.2090806@kernel.org> <4D093ABB.4030206@zytor.com> <4D0943D5.1090404@kernel.org>
In-Reply-To: <4D0943D5.1090404@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 02:40 PM, Yinghai Lu wrote:
> On 12/15/2010 02:01 PM, H. Peter Anvin wrote:
>> On 11/13/2010 05:38 PM, Yinghai Lu wrote:
>>> Index: linux-2.6/arch/x86/kernel/acpi/boot.c
>>> ===================================================================
>>> --- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
>>> +++ linux-2.6/arch/x86/kernel/acpi/boot.c
>>> @@ -198,6 +198,13 @@ static void __cpuinit acpi_register_lapi
>>>  {
>>>  	unsigned int ver = 0;
>>>  
>>> +#ifdef CONFIG_X86_64
>>> +	if (id >= (MAX_APICS-1)) {
>>> +		printk(KERN_INFO PREFIX "skipped apicid that is too big\n");
>>> +		return;
>>> +	}
>>> +#endif
>>> +
>>>  	if (!enabled) {
>>>  		++disabled_cpus;
>>>  		return;
>>
>> Why the #ifdef?
> 
> try to limit the affects to 32bit's bunch sub arch etc.
> 

I really, really don't like that... we want more unification, not less...

	-hpa
