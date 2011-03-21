Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab1CURw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:52:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42265 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab1CURww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:52:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XaNPQKbbjBWL2pePt1D4SAhlREvjSx9DanIAswm4DR0Kpdhr0BBR+aD89U3Ouas7Rc
         BwhPNSDG+OdvLy2kdrbGXxaGIkF/EecWj4f50aybHN53GMrvPT4Q58pU3Kku2tH4dWAq
         Tg8Bhzmg9TL08bt9aX4O2hfLQiWBxcEvMxtlU=
Message-ID: <4D878F7A.7070506@gmail.com>
Date: Mon, 21 Mar 2011 20:48:42 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
References: <20110321160135.GA31562@sgi.com> <20110321161425.GC23614@elte.hu> <4D877C4B.9090602@gmail.com> <4D878042.9080708@gmail.com> <4D878445.6090709@gmail.com> <20110321170832.GC12718@sgi.com> <4D87888D.4050400@gmail.com> <20110321173413.GA13916@sgi.com>
In-Reply-To: <20110321173413.GA13916@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2011 08:34 PM, Jack Steiner wrote:
....
>>>>
>>>>   I must admit I've missed the fact that Jack has tried NMIs priorities, right?
>>>> x86_platform_ops seems to be a cleaner indeed (btw I think p4 pmu kgdb issue
>>>> is exactly the same problem) but same time this might end up in over-swelled
>>>> ideas behind this small code snippet. Dunno. Probably we need some per-cpu
>>>> system status for nmi reasons other than unknown nmis...
>>>
>>> We use KDB internally, and yes, it has the same issue. The version of the
>>> patch that uses KDB OR's the "handled" status for both KDB & the UV NMI handler.
>>> If either KDB or the UV NMI handler returns "handled", the code in traps.c exits
>>> after the call to the first die notifier.
>>>
>>> Not particularily pretty but I could not find a better way to do it.
>>>
>>> --- jack
>>
>>   Another option might be to add pre-nmi notifier chain, which of course
>> not much differ from platform ops but I guess platform ops stands mostly
>> for one-shot events while chain might be more flexible. Ie I mean something
>> like
>>
>> 	if (notify_pre_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
>> 		return;
> 
> You still need to process both chains in order to handle the case where both
> hw_perf & the SGI BMC raise NMIs at about the same time.
> 
> --- jack

yes, but I meant to simply call this chain before the regular notify_die. Anyway
it would look ugly as hell too.

-- 
    Cyrill
