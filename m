Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab2HFVWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 17:22:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53017 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2HFVWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 17:22:21 -0400
Message-ID: <50203589.5020509@wwwdotorg.org>
Date: Mon, 06 Aug 2012 15:22:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] regulator: add MAX8907 driver
References: <1343932033-911-1-git-send-email-swarren@wwwdotorg.org> <20120804101918.GD9248@opensource.wolfsonmicro.com>
In-Reply-To: <20120804101918.GD9248@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2012 04:19 AM, Mark Brown wrote:
> On Thu, Aug 02, 2012 at 12:27:13PM -0600, Stephen Warren wrote:
> 
>> The MAX8907 is an I2C-based power-management IC containing voltage
>> regulators, a reset controller, a real-time clock, and a touch-screen
>> controller.

>> +static int max8907_regulator_wled_set_current_limit(struct regulator_dev *rdev,
>> +						    int min_uA, int max_uA)
> 
> I'm really not convinced it makes much sense to represent the backlight
> driver current regulators as regulators, they only get used as part of
> the backlight and are usually tightly coupled to their boosts.

So you mean just completely remove any reference to WLED from the
driver? There is a register to configure the current limit - do you not
expect anything to ever need to set that in the kernel; do you expect
the HW default to be correct, or the bootloader to set the desired value?

Thanks for the other parts of the review.
