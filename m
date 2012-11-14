Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab2KNDB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 22:01:29 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15560 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab2KNDB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 22:01:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 13 Nov 2012 19:01:26 -0800
Message-ID: <50A30986.1000507@nvidia.com>
Date: Tue, 13 Nov 2012 22:01:26 -0500
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] mfd: add TI TPS80031 mfd core driver
References: <1352646721-8350-1-git-send-email-ldewangan@nvidia.com> <1352646721-8350-2-git-send-email-ldewangan@nvidia.com> <20121113074623.GL18224@opensource.wolfsonmicro.com> <50A287F2.4070008@nvidia.com> <20121114012217.GE4415@opensource.wolfsonmicro.com> <50A30381.3000609@nvidia.com> <20121114024529.GN4415@opensource.wolfsonmicro.com>
In-Reply-To: <20121114024529.GN4415@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 09:45 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Tue, Nov 13, 2012 at 09:35:45PM -0500, Laxman Dewangan wrote:
>
>> Yes, this is not a good idea, We will need support for wakeup
>> without wakeup registers.
>> Probably we need to add one more parameter, wake enable to control
>> without wake_base.
> This does not seem sensible.  Why would this be optional if it is
> useful?  In any case, what you're doing in the driver here is clearly
> not the way forward.
>

I was thinking  of adding wake_enable in struct regmap_irq_chip and 
decide the wake support based on the value if wake_enable true or 
wake_base is non-zero. then wake support should be enable.
The wake register write will happen only when wake_base is non-zero.

