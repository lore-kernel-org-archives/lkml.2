Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab1DNUFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:05:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37224 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243Ab1DNUFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:05:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iEZQvgtdWjUdXHXNSxtIh2MgwwMo4I3cgZgGmWdCHZZJi9y+UT6tL1cRpRxv34OLAY
         LcF72YL76nPoCtNjmCUpe8KYo2DLRQGCPe2dfz5VfLN1DEa+FSw6A8Lbhlzh2emJ4Urz
         1EDGuVf8XSNZ/pmF115+H9mz7CY5Yak7J7hqI=
Message-ID: <4DA75373.9040705@openvz.org>
Date: Fri, 15 Apr 2011 00:05:07 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
References: <4DA70950.3060102@openvz.org> <20110414174327.GA8863@elte.hu> <20110414183231.GN16939@redhat.com> <20110414184606.GD16064@elte.hu> <4DA74E5D.4060002@openvz.org> <20110414195748.GO16939@redhat.com>
In-Reply-To: <20110414195748.GO16939@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 11:57 PM, Don Zickus wrote:
> On Thu, Apr 14, 2011 at 11:43:25PM +0400, Cyrill Gorcunov wrote:
>> On 04/14/2011 10:46 PM, Ingo Molnar wrote:
>>>
>>> btw., the bug went away once i removed your patch so it's 100% sure caused by 
>>> this change.
>>>
>>> Thanks,
>>>
>>> 	Ingo
>>
>> Ingo if you have a chance mind to give this patch a shot please? Seems we might miss unmasking
>> for inflight nmis.
> 
> I don't think this patch will work.  It would make sense if the unmasking
> happened _after_ the "if (!handled)" path, but that is not the path Ingo
> wanted for v1.

This thing happened if inflight nmi reaches the system and note that inflight
NMI comes from perf and masks lvt entry, it has nothing to do with "handled" but
rather the _fact_ that NMI reached apic via LVTPC and as result -- masked it.
Don, I might be missin something, brain is slowly going to sleep :)

> 
> Cheers,
> Don
> 
>> -	apic_write(APIC_LVTPC, APIC_DM_NMI);
>>
>>  	handled = x86_pmu.handle_irq(args->regs);
>> +	apic_write(APIC_LVTPC, APIC_DM_NMI);
> 
> ^^^^ all handled/unhandled NMIs hit that apic_write
>>  	if (!handled)
>>  		return NOTIFY_DONE;
>>

yeah, Ingo asked to make it this way -- ie like in your former
patch, the conditional unmasking is left to be tested in further
kernel series.

-- 
    Cyrill
