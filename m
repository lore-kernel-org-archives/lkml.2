Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab1JRSwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:52:07 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:58550 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab1JRSwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:52:06 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Oct 2011 14:52:05 EDT
Message-ID: <4E9DC88F.4070803@slimlogic.co.uk>
Date: Tue, 18 Oct 2011 19:42:23 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Kyle Manna <kyle.manna@fuel7.com>
CC: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@ti.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Subject: Re: [PATCH 0/6] mfd: TPS65910 bug fixes and enhancements
References: <1318962388-26151-1-git-send-email-kyle.manna@fuel7.com>
In-Reply-To: <1318962388-26151-1-git-send-email-kyle.manna@fuel7.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/10/11 19:26, Kyle Manna wrote:
> This series of patches fixes a number of small problems with the TPS65910 that
> were discovered on a custom board.
>
> Additionally, the last patch enhances the platform to driver interface using the
> TWL4030 series of regulators as an example.
>
> Kyle Manna (6):
>    mfd: TPS65910: Handle non-existent devices
>    mfd: TPS65910: Add I2C slave address macros
>    mfd: TPS65910: Fix typo that clobbers genirq
>    mfd: TPS65910: Move linux/gpio.h include to header
>    mfd: TPS65910: Fix tps65910_set_voltage
>    mfd: TPS65910: Improve regulator init data
>
>   drivers/mfd/tps65910.c                 |   23 ++-
>   drivers/regulator/tps65910-regulator.c |  246 +++++++++++++++++++++++++-------
>   include/linux/mfd/tps65910.h           |   36 +++++-
>   3 files changed, 247 insertions(+), 58 deletions(-)
>
In my opinion patches 5 and 6 are regressions.

set_voltage_sel was added to core api to allow the voltage selection 
code that a lot of drivers implemented identically to be abstracted to 
the regulator core.

The twl4030 driver method of defining platform data has left us with a 
very inflexible way of adding functionality when a new variant of the 
chip is released. This was remarked on by a number of kernel developers 
when I upstreamed the twl6025 support. I feel copying the twl driver is 
the wrong direction to go in in this regard.

Graeme

