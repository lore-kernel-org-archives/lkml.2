Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1DSQOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:14:15 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:50800 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab1DSQOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:14:12 -0400
Message-ID: <4DADB2F1.1080405@linaro.org>
Date: Tue, 19 Apr 2011 10:06:09 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, ohad@wizery.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ux500: Adding support for u8500 Hsem functionality
 V2
References: <1302535464-12294-1-git-send-email-mathieu.poirier@linaro.org> <201104121946.01618.arnd@arndb.de> <4DA4A44D.5020208@linaro.org> <201104172239.57362.arnd@arndb.de>
In-Reply-To: <201104172239.57362.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-17 02:39 PM, Arnd Bergmann wrote:
> On Tuesday 12 April 2011, Mathieu Poirier wrote:
>>> struct u8500_hsem_state {
>>>        void __iomem *io_base;
>>>        struct u8500_hsem hsem[U8500_MAX_SEMAPHORE];
>>> }
>> I don't see the real advantage in doing a single allocation - the
>> dynamic allocation method is also used in 'omap_hwspinlock.c'.  Is
>> modification mandatory to get the driver accepted ?
> Not strictly required, but somewhat cleaner IMHO. If you have a good
> reason for splitting the allocations, just document that clearly.
I don't have a reason other than I thought what was found in 
omap_hwspinlock.c looked perfectly fine to me and there was no reason to 
proceed otherwise in 'u8500_hsem.c'.
> One more thing I just noticed: the hwspinlock_internal.h file defines
> the hwspinlock->id field as "a global, unique, system-wide, index of
> the lock", but the u8500 hsem just sets it to an integer starting
> at zero. If there are multiple devices providing hwspinlocks in the
> same system, that cannot work.
>
> 	Arnd
I have to admit I'm not sure of what your asking here.  Hwspinlocks 
should be administered by only one entity and this is what this driver 
is doing.

Please get back to me with a clarification.


