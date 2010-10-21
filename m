Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab0JURsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:48:03 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:46014 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564Ab0JURsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:48:01 -0400
Message-ID: <4CC07CB4.9060108@metafoo.de>
Date: Thu, 21 Oct 2010 19:47:32 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: rklein@nvidia.com, broonie@opensource.wolfsonmicro.com, achew@nvidia.com,
        olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] POWER: Add gpio charger driver
References: <1287663957-30099-1-git-send-email-lars@metafoo.de> <1287676501-23254-1-git-send-email-lars@metafoo.de> <20101021162617.GA10447@oksana.dev.rtsoft.ru>
In-Reply-To: <20101021162617.GA10447@oksana.dev.rtsoft.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> On Thu, Oct 21, 2010 at 05:55:01PM +0200, Lars-Peter Clausen wrote:
>> This patch adds a simple driver for chargers indicating their online status
>> through a GPIO pin.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> Hm. I'm getting older, it seems. Now can anybody remind me why
> pda_power.c doesn't work here? ;-)
> 
> This driver looks like a light-weigh version of pda_power, except
> that it can do GPIOs directly (instead of is_*_online() callbacks).
> 
> Can we instead improve pda_power? Like this:
> 
> 	if (!pdata->is_ac_online && pdata->ac_monitor_gpio)
> 		pdata->is_ac_online = pda_ac_monitor_gpio;
> 
> Should look quite cool, I think.
> 
> (Plus, we might get rid of ac/usb stuff in that driver, and 
> pass enum power_supply_type to the callbacks instead).
> 

Hi

Hm... I guess it can be, but on the other hand most platform bus chargers type
devices can be, because the pda_power driver is keep pretty generic with custom init,
status and exit callbacks.

- Lars
