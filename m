Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab2JIGzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:55:16 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4914 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab2JIGzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:55:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 08 Oct 2012 23:52:58 -0700
Message-ID: <5073C25F.4030900@nvidia.com>
Date: Tue, 9 Oct 2012 11:51:19 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>, "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] regulator: tps65090: add external control support
 for DCDC
References: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com> <1349536671-31714-7-git-send-email-ldewangan@nvidia.com> <20121009062841.GL8237@opensource.wolfsonmicro.com>
In-Reply-To: <20121009062841.GL8237@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2012 11:58 AM, Mark Brown wrote:
> On Sat, Oct 06, 2012 at 08:47:51PM +0530, Laxman Dewangan wrote:
>> The TPS65090's DCDC outut can also be enable/disable through the
>> external digital input signal. Add support for enable/disable
>> either through register access via I2C or through external
>> control inputs. The external control inputs can be driven through
>> GPIOs also and hence adding support for passing the GPIO number.
> There's support for GPIO driven enable lines in the framework already,
> this driver should be able to use this happily, this sort of hardware is
> exactly the use case it was written for.

yes, I am using the gpio driven enable lines in the framework.
This patch does the some configuration in register to enable external
control and configure the regulator_config (fill gpio related stuff in 
config)  before registering
the regulator. There is no call of gpio libs from the driver.

