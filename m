Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab1ASMoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 07:44:05 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64373 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab1ASMoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 07:44:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=R4wEtZVXj1/uPBQKyPwzDKRJ/0LfOjOfK6hM/ruwqqs8phyEJRi2WR5/ePlyYNMlc3
         FPZMcGCo565Pg4Ui3BxvYzkSSjZ6sttPC3nsgjB0YllgJFymKpzVqV5IFUc4pR5duE/L
         zxSfEpuPIts5FoFU8TJdYC/utRRTWgDMkE4Cc=
Message-ID: <4D36DC8D.50705@gmail.com>
Date: Wed, 19 Jan 2011 13:43:57 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Greg KH <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/hv/osd: don't reimplement ALIGN macro
References: <1295365151-9527-1-git-send-email-u.kleine-koenig@pengutronix.de>	<20110119053715.GA26304@suse.de> <20110119085456.GI10686@pengutronix.de>
In-Reply-To: <20110119085456.GI10686@pengutronix.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2011 09:54 AM, Uwe Kleine-König wrote:
> On Tue, Jan 18, 2011 at 09:37:15PM -0800, Greg KH wrote:
>> On Tue, Jan 18, 2011 at 04:39:11PM +0100, Uwe Kleine-König wrote:
>>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>>> ---
>>>  drivers/staging/hv/osd.h |    5 ++---
>>>  1 files changed, 2 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/staging/hv/osd.h b/drivers/staging/hv/osd.h
>>> index ce064e8..61ae54c 100644
>>> --- a/drivers/staging/hv/osd.h
>>> +++ b/drivers/staging/hv/osd.h
>>> @@ -28,10 +28,9 @@
>>>  #include <linux/workqueue.h>
>>>  
>>>  /* Defines */
>>> -#define ALIGN_UP(value, align)	(((value) & (align-1)) ?		\
>>> -				 (((value) + (align-1)) & ~(align-1)) :	\
>>> -				 (value))
>>> +#define ALIGN_UP(value, align)		ALIGN((value), (align))
>>
>> How about dropping ALIGN_UP entirely and just using the built-in ALIGN()
>> macro instead?
> Can do.
> 
>>>  #define ALIGN_DOWN(value, align)	((value) & ~(align-1))
>>
>> Any chance to get rid of this as well with the ALIGN() macro, or is that
>> really not possible?
> it would be
> 
> 	#define ALIGN_DOWN(value, align) ALIGN((value) - (align) + 1, (align))
> 
> I think, but as it's only used once it might be easier to just use ALIGN
> there, too.
> 
> BTW, it's used as follows:
> 
> 	#define NUM_PAGES_SPANNED(addr, len)    ((ALIGN(addr+len, PAGE_SIZE) - \
> 						 ALIGN_DOWN(addr, PAGE_SIZE)) >>  \
> 						 PAGE_SHIFT)

(DIV_ROUND_UP(addr+len, PAGE_SIZE) - ((addr) >> PAGE_SHIFT)))

or maybe better

(PAGE_ALIGN(addr+len) >> PAGE_SHIFT - ((addr) >> PAGE_SHIFT))

> I wonder if there is already a function yielding this value?
> Wouldn't
> 
> 	((addr + len) >> PAGE_SHIFT) - (addr >> PAGE_SHIFT) + 1

No, this won't work (it's not equivalent).

regards,
-- 
js
