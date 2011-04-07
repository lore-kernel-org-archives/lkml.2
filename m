Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab1DGWlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:41:06 -0400
Received: from mail1.nippynetworks.com ([91.220.24.129]:59322 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab1DGWlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:41:04 -0400
Message-ID: <4D9E3D7D.3090601@wildgooses.com>
Date: Thu, 07 Apr 2011 23:41:01 +0100
From: Ed W <lists@wildgooses.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: kernel@wildgooses.com, Grant Likely <grant.likely@secretlab.ca>,
        daniel@caiaq.de, Andres Salomon <dilinger@queued.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: New PCEngines Alix LED driver using gpio interface
References: <1299430285-13189-1-git-send-email-kernel@wildgooses.com> <20110407145836.3cde7699.akpm@linux-foundation.org>
In-Reply-To: <20110407145836.3cde7699.akpm@linux-foundation.org>
X-TagToolbar-Keys: D20110407234100999
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2011 22:58, Andrew Morton wrote:
> On Sun,  6 Mar 2011 16:51:25 +0000
> kernel@wildgooses.com wrote:
>
>> From: Ed Wildgoose <kernel@wildgooses.com>
>>
>> This new driver replaces the old PCEngines Alix 2/3 LED driver with
>> a new driver that controls the LEDs through the leds-gpio driver.
>> The old driver accessed GPIOs directly, which created a conflict 
>> and prevented also loading the cs5535-gio driver to read other
>> GPIOs on the Alix board. With this new driver, both are loaded
>> and therefore it's possible to access both the LEDs and onboard GPIOs 
>>
>> This driver is based on leds-net5501.c 
>> by: Alessandro Zummo <a.zummo@towertech.it>
>> Additionally it relies on parts of the patch: 7f131cf3ed
>> by: Daniel Mack <daniel@caiaq.de> to perform detection of the Alix board
> As far as I can tell from looking at it, this driver maintains all the
> same interfaces and behaviour as the old version.  Am I right?
>

Yes, this is correct.  The substance of the change is simply to use the
leds-gpio interface rather than fiddling with gpio settings directly. 
However, please note that Grant and Andres suggested that the driver
should instead move to "arch" and out of leds? Therefore, I created an
updated version of this patch which you can find from message id:
"1300553466-23873-1-git-send-email-kernel@wildgooses.com", ie:
    http://lists.zerezo.com/linux-kernel/msg27455553.html

Additionally this updated patch has a slightly amended copyright -
several folks thought that the updated copyright statement was more
appropriate

My apologies that this updated patch was not more clearly marked as such
- Grant has taken the time to point out how I should submit patches more
clearly in the future

I would be happy to shuffle the code around further if anyone has an
opinion?

Thanks for picking this up

Ed W

