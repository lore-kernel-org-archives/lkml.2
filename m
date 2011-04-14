Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab1DNRqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:46:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61929 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab1DNRqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QaHVfSss3FdlZmItnopjw5KoJxt10ZWAD0qMcDoHuEoB/9Zdg18UO/ZmTheYLfo59U
         a+4c4mVpZuUvvaxWC3jQ4Zw/rd6PtybFrudbPs1HXvsnCEqCdotCKEr7Emc41+C4Gsdg
         AAqVSgH2KbHX91B/LJfxBOGSFBhrF7Azux+D0=
Message-ID: <4DA732D8.9040602@openvz.org>
Date: Thu, 14 Apr 2011 21:46:00 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
References: <4DA70950.3060102@openvz.org> <20110414174327.GA8863@elte.hu>
In-Reply-To: <20110414174327.GA8863@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 09:43 PM, Ingo Molnar wrote:
...
>>
>>  	handled = x86_pmu.handle_irq(args->regs);
>> +
>> +	/*
>> +	 * Note the unmasking of LVTPC entry must be
>> +	 * done *after* counter oveflow flag is cleared
>> +	 * otherwise it might lead to double NMIs generation.
>> +	 */
>> +	apic_write(APIC_LVTPC, APIC_DM_NMI);
>> +
>>  	if (!handled)
>>  		return NOTIFY_DONE;
>>
> 
> This breaks 'perf top' on Intel Nehalem and probably other CPUs. The NMI gets 
> stuck fast on all CPUs:
> 
>   NMI: 16 6 3 3 3 3 3 3 3 3 3 3 3 3 4 5 Non-maskable interrupts
> 
> Thanks,
> 
> 	Ingo

Hmm. Thanks for info. Investigating...

-- 
    Cyrill
