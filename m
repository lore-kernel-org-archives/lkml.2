Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab2KNDvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 22:51:55 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19022 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab2KNDvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 22:51:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 13 Nov 2012 19:51:51 -0800
Message-ID: <50A31557.30704@nvidia.com>
Date: Tue, 13 Nov 2012 22:51:51 -0500
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] mfd: add TI TPS80031 mfd core driver
References: <1352646721-8350-1-git-send-email-ldewangan@nvidia.com> <1352646721-8350-2-git-send-email-ldewangan@nvidia.com> <20121113074623.GL18224@opensource.wolfsonmicro.com> <50A287F2.4070008@nvidia.com> <20121114012217.GE4415@opensource.wolfsonmicro.com> <50A30381.3000609@nvidia.com> <20121114024529.GN4415@opensource.wolfsonmicro.com> <50A30986.1000507@nvidia.com> <20121114030412.GO4415@opensource.wolfsonmicro.com>
In-Reply-To: <20121114030412.GO4415@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 10:04 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Tue, Nov 13, 2012 at 10:01:26PM -0500, Laxman Dewangan wrote:
>
>>> This does not seem sensible.  Why would this be optional if it is
>>> useful?  In any case, what you're doing in the driver here is clearly
>>> not the way forward.
>> I was thinking  of adding wake_enable in struct regmap_irq_chip and
>> decide the wake support based on the value if wake_enable true or
>> wake_base is non-zero. then wake support should be enable.
>> The wake register write will happen only when wake_base is non-zero.
> But to repeat my question why would this be optional?
>

OK, I wanted to make this configurable to preserve the current 
functional behavior although I always want to be wakeup from PMIC 
devices i.e. gpio or rtc or onkey etc.
If I understand your statement then the wake support should be there and 
should enable the wake even if there is no wake_base. The irq_set_wake() 
should be called for parent irq if client have called the irq_set_wake() 
with interrupts supported by this regmap-irq.

