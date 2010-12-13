Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab0LMQxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 11:53:40 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44233 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab0LMQxj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 11:53:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=v7LFYxRPCt1OCpu3Uur72ndMBztKr9S7yKBnuGbGwhHCQHzJLvKfI/a6QqE/KZTmHr
         TCDKiRUAp2FLPcI2tQ38XGwg9Ic4nTeHMtZNYhJToaEIyh7UqjXDTq8vTZFFVxX0531U
         ig5hrp28aDsVQ6Asw+9T5Bu3jvRXkAM/NE8ps=
MIME-Version: 1.0
In-Reply-To: <AANLkTimkUpgPD5BdjL-3aV=miJwbT0OOWAJJ+V7LUhbP@mail.gmail.com>
References: <-1357135968697415881@unknownmsgid>
	<AANLkTimkUpgPD5BdjL-3aV=miJwbT0OOWAJJ+V7LUhbP@mail.gmail.com>
Date: Mon, 13 Dec 2010 16:53:37 +0000
X-Google-Sender-Auth: PI7BC47uVzhlK0Lp9CtYyf6MpfU
Message-ID: <AANLkTi=VaayMuiU-RXnL40gf3_y0YWYvOWayDofdDmpL@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] msm: hotplug: support cpu hotplug on msm
From: Catalin Marinas <catalin.marinas@arm.com>
To: ykaoua@qualcomm.com
Cc: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 December 2010 15:12, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On 13 December 2010 01:20,  <ykaoua@qualcomm.com> wrote:
>> --- /dev/null
>> +++ b/arch/arm/mach-msm/hotplug.c
> [...]
>> +static inline void platform_do_lowpower(unsigned int cpu)
>> +{
>> +       /* Just enter wfe for now. */
>> +       for (;;) {
>> +               asm("wfe");
>> +               if (pen_release == cpu) {
>> +                       /*
>> +                        * OK, proper wakeup, we're done
>> +                        */
>> +                       break;
>> +               }
>> +               smp_rmb();
>
> Do you need some barrier after wfe?

I checked with the hw people and it looks like we don't need a DSB
after an WFE (as you have in headsmp.S) since the hardware doesn't
speculate the loads beyond the WFE (lower power state). But in the
above case you may need some compiler barrier to avoid code
reordering.

-- 
Catalin
