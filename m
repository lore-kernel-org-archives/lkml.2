Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab1GFNPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 09:15:37 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:46905 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab1GFNPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 09:15:36 -0400
Message-ID: <4E145F6D.8010708@mvista.com>
Date: Wed, 06 Jul 2011 17:13:17 +0400
From: Vitaly Kuzmichev <vkuzmichev@mvista.com>
Reply-To: vkuzmichev@mvista.com
Organization: MontaVista Software, LLC
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, Wim Van Sebroeck <wim@iguana.be>,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>, Nicolas Pitre <nico@fluxnic.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 3/6] mpcore_wdt: Fix WDIOC_SETOPTIONS handling
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <1309892440-3260-4-git-send-email-vkuzmichev@mvista.com> <201107061422.38705.arnd@arndb.de>
In-Reply-To: <201107061422.38705.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 07/06/2011 04:22 PM, Arnd Bergmann wrote:
> On Tuesday 05 July 2011, Vitaly Kuzmichev wrote:
>>
>> According to the include/linux/watchdog.h WDIOC_SETOPTIONS is
>> classified as 'read from device' ioctl call:
>>   #define WDIOC_SETOPTIONS        _IOR(WATCHDOG_IOCTL_BASE, 4, int)
>>
>> However, the driver 'mpcore_wdt' performs 'copy_from_user' only if
>> _IOC_WRITE is set, thus the local variable 'uarg' which is used in
>> WDIOC_SETOPTIONS handling remains uninitialized.
>>
>> The proper way to fix this is to bind WDIOC_SETOPTIONS to _IOW,
>> but this will break compatibility.
>> So adding additional condition for performing 'copy_from_user'.
>>
>> Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>
> 
> Is the new watchdog driver core ready for 3.1? If so, the best
> solution would be to get rid of the entire ioctl function in
> the mpcore_wdt driver and just use the core for that.

In this case the whole mpcore_wdt driver should be rewritten.
And then this should be done in a separate set of patches, I think.
And this may take more time than is seems now.
So I would keep this patch.


Thanks,
Vitaly.
