Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2BTBwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 20:52:51 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59974 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab2BTBwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 20:52:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rmallon@gmail.com designates 10.68.236.167 as permitted sender) smtp.mail=rmallon@gmail.com; dkim=pass header.i=rmallon@gmail.com
Message-ID: <4F41A76D.1070409@gmail.com>
Date: Mon, 20 Feb 2012 12:52:45 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Lightning/1.0b2 Thunderbird/3.1.18
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/18] ARM: at91: make ST (System Timer) soc independent
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com> <957702b1ff83afcc0a8e842f53f05ff3f40b78b3.1329500622.git.nicolas.ferre@atmel.com> <4F419246.6080405@gmail.com> <20120220013825.GD29599@game.jcrosoft.org>
In-Reply-To: <20120220013825.GD29599@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/02/12 12:38, Jean-Christophe PLAGNIOL-VILLARD wrote:

> On 11:22 Mon 20 Feb     , Ryan Mallon wrote:
>> On 18/02/12 04:49, Nicolas Ferre wrote:
>>
>>> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>>>
>>> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
>>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>> ---
>>>  arch/arm/mach-at91/at91rm9200.c              |    4 +-
>>>  arch/arm/mach-at91/at91rm9200_time.c         |   37 ++++++++++++++++----------
>>>  arch/arm/mach-at91/generic.h                 |    1 +
>>>  arch/arm/mach-at91/include/mach/at91_st.h    |   32 +++++++++++++++-------
>>>  arch/arm/mach-at91/include/mach/at91rm9200.h |    2 +-
>>>  drivers/watchdog/at91rm9200_wdt.c            |    8 +++---
>>>  6 files changed, 53 insertions(+), 31 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
>>
>> Hi Jean, Nicolas,
>>
>> Patch looks mostly good, couple of points below.
>>
>> ~Ryan
>>
>> <snip>
>>
>>>  	/* Cancel any pending alarm; flush any pending IRQ */
>>> -	at91_sys_write(AT91_ST_RTAR, alm);
>>> -	(void) at91_sys_read(AT91_ST_SR);
>>> +	at91_st_write(AT91_ST_RTAR, alm);
>>> +	(void) at91_st_read(AT91_ST_SR);
>>
>>
>> Can we please remove the (void) casting of the return value when making
>> this change, especially since at91_st_read is now a macro which doesn't
>> even have a return value. Same in a few other places.
> modification done by script and it's no the scope of this patch


That isn't an excuse to leave incorrect code there. It is a simple fix.

~Ryan
