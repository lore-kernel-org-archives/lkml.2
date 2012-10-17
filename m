Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab2JQT4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 15:56:51 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11577 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab2JQT4t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 15:56:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 17 Oct 2012 12:56:35 -0700
From: Philip Rakity <prakity@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        Chris Ball <cjb@laptop.org>, Russell King <linux@arm.linux.org.uk>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@stericsson.com>
Date: Wed, 17 Oct 2012 21:56:32 +0200
Subject: Re: [PATCH 1/2] mmc: core: Support all MMC capabilities when
 booting from Device Tree
Thread-Topic: [PATCH 1/2] mmc: core: Support all MMC capabilities when
 booting from Device Tree
Thread-Index: Ac2soYDPtQw1Mx67Rw2Ovn8F0e+ZvQ==
Message-ID: <1B3089FB-EDBE-4145-83A6-1DFA4B0A2FDF@nvidia.com>
References: <1350306959-5843-1-git-send-email-lee.jones@linaro.org>
 <201210151420.29930.arnd@arndb.de> <20121015160740.GC7662@gmail.com>
 <201210171338.01011.arnd@arndb.de>
In-Reply-To: <201210171338.01011.arnd@arndb.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 17 Oct 2012, at 14:38, Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 15 October 2012, Lee Jones wrote:
>>> and so on. What are you actually missing in the properties that
>>> are already there?
>> 
>> MMC_CAP_ERASE
> 
> This one seems to be set unconditionally on some controllers but
> not on others. Why would it need to be configurable?
> 
>> MMC_CAP_UHS_SDR12
>> MMC_CAP_UHS_SDR25
>> MMC_CAP_UHS_DDR50
> 
> Could this be derived from max-frequency?

The problem is the controller may signal it supports DDR but the host cannot.  For example no voltage at correct level.
Same issue with 8 bit support.  Controller could say supports it but board has only 4 "wires"
> 
>> MMC_CAP_1_8V_DDR
> 
> Right, I suppose we need this. Should we have a minimum and maximum
> voltage added to the common properties for this?
> 
>> MMC_CAP2_DETECT_ON_ERR
>> MMC_CAP2_NO_SLEEP_CMD
> 
> I don't see these ones being set anywhere, but they were both
> added by Ulf. Maybe he can comment on if or why they are needed
> in devicetree, rather than being set by the driver unconditionally
> or for specific versions of the host controller.
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

