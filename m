Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab1GGOM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:12:29 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:55989 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab1GGOM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:12:26 -0400
Message-ID: <4E15BE34.3010807@mvista.com>
Date: Thu, 07 Jul 2011 18:09:56 +0400
From: Vitaly Kuzmichev <vkuzmichev@mvista.com>
Reply-To: vkuzmichev@mvista.com
Organization: MontaVista Software, LLC
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>, Marc Zyngier <marc.zyngier@arm.com>,
        Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        Valentine Barshak <vbarshak@mvista.com>
Subject: Re: [PATCH V3 2/4] ARM: smp_twd: mpcore_wdt: Fix watchdog counter
 loading
References: <1310041339-2348-1-git-send-email-vkuzmichev@mvista.com> <1310041396-2461-2-git-send-email-vkuzmichev@mvista.com> <201107071444.19569.arnd@arndb.de>
In-Reply-To: <201107071444.19569.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 07/07/2011 04:44 PM, Arnd Bergmann wrote:
> On Thursday 07 July 2011, Vitaly Kuzmichev wrote:
>> Although the commit "98af057092f8f0dabe63c5df08adc2bbfbddb1d2
>>  ARM: 6126/1: ARM mpcore_wdt: fix build failure and other fixes"
>> resolved long standing mpcore_wdt driver build problems, it
>> introduced an error in the relationship between the MPcore watchdog
>> timer clock rate and mpcore_margin, "MPcore timer margin in seconds",
>> such that watchdog timeouts are now arbitrary rather than the number
>> of seconds specified by mpcore_margin.
>>
>> This change restores mpcore_wdt_keepalive() to its equivalent
>> implementation prior to commit 98af057 such that watchdog timeouts now
>> occur as specified by mpcore_margin.
>>
>> The variable 'mpcore_timer_rate' which caused that build failure was
>> replaced by 'twd_timer_rate'. Adding exported function to obtain
>> 'twd_timer_rate' value in mpcore_wdt driver.
>>
>> MPCORE_WATCHDOG needed to build 'mpcore_wdt' already depends on
>> HAVE_ARM_TWD needed to build 'smp_twd', so from the point of view of
>> 'mpcore_wdt' driver the exported function will always exist.
>>
>> Signed-off-by: Valentine Barshak <vbarshak@mvista.com>
>> Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>
> 
> Looks good now,

Unfortunately, I forgot to change to change EXPORT_SYMBOL ->
EXPORT_SYMBOL_GPL.
Ignore this patch and review PATCH V4 2/4 instead.
Sorry for troubles.
