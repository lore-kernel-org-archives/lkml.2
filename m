Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab1E3Fm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 01:42:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43229 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab1E3Fm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 01:42:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE32E38.7010608@jp.fujitsu.com>
Date: Mon, 30 May 2011 14:42:16 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 03/12] mce-severity: cleanup severity table
References: <4DDF21DE.9040705@jp.fujitsu.com> <4DDF22FA.4020406@jp.fujitsu.com> <20110527064647.GC16811@liondog.tnic> <20110527075409.GA19300@elte.hu>
In-Reply-To: <20110527075409.GA19300@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/27 16:54), Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@alien8.de> wrote:
> 
>>> -	BITSET(
>>> -		MCI_STATUS_PCC,
>>> -		PANIC, "Processor context corrupt"
>>> +	MCESEV(
>>> +		PANIC, "Processor context corrupt",
>>> +		BITSET(MCI_STATUS_PCC)
>>>  		),
>>
>> I'm still wondering whether using the gcc struct assignment syntax could
>> make those much more readable instead of changing the macro inclusion:
>>
>> 	{
>> 		.sev	= MCE_PANIC_SEVERITY,
>> 		.msg	= "Processor context corrupt",
>> 		.mask	= MCI_STATUS_PCC,
>> 		.result	= MCI_STATUS_PCC,
>> 	},
>> 	...
> 
> Hidetoshi's version was already an improvement over what we have 
> currently (what we have now is largely unreadable), but your variant 
> looks even more readable and isnt all that much longer either.
> 
> So, the case for macros is where the initialization can be compressed 
> into a single *readable* line. If that cannot be done then the least 
> obfuscated version is generally the better one.

Maybe in later we can have another patch to make this table to use
the gcc's syntax if it is really required. And also it would worth
considering to re-implement this severity-leveling without the table.

Since this is a part of "minor" change set and I still like my version
with existing packed conditions, so at the moment I'd like to keep this
patch as a non-intrusive change.


Thanks,
H.Seto

