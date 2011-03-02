Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab1CBTtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:49:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38956 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab1CBTtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:49:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=m+UC5X+DSLMaQAAkUcoPROEcpi+W9XITRiyvPJNL+7oLxWu4WmjfjR2ujxwsgRxBka
         /IHe7AfgX85CNZysfKx0iCVBjn9j3cKtPfLKKWi0XQPsc5VywjPfbB5qfVruN3nukETr
         HYNDDhBR7tj9S79/GPLnTzVs3kQyULlzXFT9M=
Message-ID: <4D6E9F3F.5020708@openvz.org>
Date: Wed, 02 Mar 2011 22:49:19 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 1/2 resend] x86, nmi: Define a name for NMI control
 port
References: <4D6E630E.1070107@openvz.org> <20110302193533.GY11359@redhat.com>
In-Reply-To: <20110302193533.GY11359@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 10:35 PM, Don Zickus wrote:
> On Wed, Mar 02, 2011 at 06:32:30PM +0300, Cyrill Gorcunov wrote:
>> Also add a comment anout why we need in-out operations.
>>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>> ---
>>
>> Ingo I hope this time I've resolved MUA space injection.
>>
>>  arch/x86/include/asm/mach_traps.h |   18 +++++++++++++-----
>>  1 file changed, 13 insertions(+), 5 deletions(-)
>>
>> Index: linux-2.6.git/arch/x86/include/asm/mach_traps.h
>> =====================================================================
>> --- linux-2.6.git.orig/arch/x86/include/asm/mach_traps.h
>> +++ linux-2.6.git/arch/x86/include/asm/mach_traps.h
>> @@ -8,6 +8,7 @@
>>  #include <asm/mc146818rtc.h>
>>
>>  #define NMI_REASON_PORT		0x61
>> +#define NMI_ENABLE_PORT		0x70 /* Real-Time Clock Address Register as well */
>>
>>  #define NMI_REASON_SERR		0x80
>>  #define NMI_REASON_IOCHK	0x40
>> @@ -30,12 +31,19 @@ static inline void reassert_nmi(void)
>>  		old_reg = current_lock_cmos_reg();
>>  	else
>>  		lock_cmos(0); /* register doesn't matter here */
>> -	outb(0x8f, 0x70);
>> -	inb(0x71);		/* dummy */
> 
> I was wondering if 0x71 should get a name change too.  Then again I can't
> find the Intel doc that tells me what 0x70 is either (I remember seeing it
> somewhere).
> 
> Cheers,
> Don

  Well, me specs are on another machine (which I didn't copied back yet :) but
if my memory doesn't betray me it can be found in ICH specification. For 0x71 i
simply don't remember how it's named in spec but it stands for RTC ram target
register iirc.

-- 
    Cyrill
