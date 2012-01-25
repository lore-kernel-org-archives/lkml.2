Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab2AYOIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 09:08:06 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10589 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab2AYOIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 09:08:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 25 Jan 2012 06:08:00 -0800
Message-ID: <4F200C93.30502@nvidia.com>
Date: Wed, 25 Jan 2012 19:37:15 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>, "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2] regulator: tps65910: Sleep control through external
 inputs
References: <1327489068-9460-1-git-send-email-ldewangan@nvidia.com> <20120125124250.GH3687@opensource.wolfsonmicro.com> <4F1FF9EF.9000004@nvidia.com> <20120125125020.GI3687@opensource.wolfsonmicro.com>
In-Reply-To: <20120125125020.GI3687@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 January 2012 06:20 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Wed, Jan 25, 2012 at 06:17:43PM +0530, Laxman Dewangan wrote:
>> On Wednesday 25 January 2012 06:12 PM, Mark Brown wrote:
>>> This really isn't what the set_mode() API is for - especially the fact
>>> that it supports turning the regulator off which really isn't what
>>> set_mode() is supposed to do.  A generic driver using this API isn't
>>> going to play too well.
>> Then what should be the method? Is it through the macro similar to
>> patch V1 where LOW_POWER mode option come from platform data? The
>> idea  is to set the regulator in OFF or low power mode based on
>> external control.
> Like I said we've got the various suspend callbacks for setting the
> behaviour in suspend mode.
Then in this case, I will implement the
set_suspend_enable() and put the device in low power mode.
set_suspend_disable() and put the device in full power, normal mode.
set_suspend_mode(): based on mode and external control, either it will 
call existing set_mode() if it is not externally controlled otherwise 
set the mode locally for the case of externally controlled.

The board file will set the regulator_state accordingly for a given 
requirements through the constraints.

Does it make sense?


> * Unknown Key
> * 0x6E30FDDD

