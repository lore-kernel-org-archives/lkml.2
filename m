Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab1L3PHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 10:07:17 -0500
Received: from mail.tpi.com ([70.99.223.143]:3088 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab1L3PHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 10:07:15 -0500
Message-ID: <4EFDD39D.30802@canonical.com>
Date: Fri, 30 Dec 2011 08:07:09 -0700
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jonathan Nieder <jrnieder@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Phil Miller <mille121@illinois.edu>
Subject: Re: [27/27] clockevents: Set noop handler in clockevents_exchange_device()
References: <20111207165611.GA19872@kroah.com> <20111207165602.672902223@clark.kroah.org> <20111229120956.GA31878@elie.Belkin> <CA+55aFxzM0DamY13ZP_xnOzvcTfyyZtHFc8gismerqDVvGiuWA@mail.gmail.com>
In-Reply-To: <CA+55aFxzM0DamY13ZP_xnOzvcTfyyZtHFc8gismerqDVvGiuWA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2011 06:05 PM, Linus Torvalds wrote:
> On Thu, Dec 29, 2011 at 4:09 AM, Jonathan Nieder<jrnieder@gmail.com>  wrote:
>>
>> This is basically the reverse of 7c1e768974 (clockevents: prevent
>> clockevent event_handler ending up handler_noop, 2008-09-03).  The
>> rationale for the latter still applies.
>
> Hmm. You seem to be right. Instead of applying this to stable, it
> looks like we should revert it from mainline.
>
>>                    People have been reporting
>> the analagous patch to this one causing hangs on resume in 3.1.y and
>> 3.2 release candidates:
>>
>>   - http://thread.gmane.org/gmane.linux.kernel/1233033
>>   - http://thread.gmane.org/gmane.linux.kernel/1233389
>>   - http://thread.gmane.org/gmane.linux.kernel/1233159
>>   - http://thread.gmane.org/gmane.linux.kernel/1227868/focus=1230877
>>
>> So please consider reverting it for now.
>
> Thomas? It does seem to be broken and there do seem to be regression
> reports about it.
>
> Should I revert it, or do you have alternative fixes?
>
>                   Linus
> --

We (Ubuntu) are seeing this issue as well in both 3.0.13 and 3.2-rc6:

https://lkml.org/lkml/2011/12/24/33

Reverting that single patch alleviates the resume regression.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
