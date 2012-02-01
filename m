Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab2BARhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:37:42 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5272 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab2BARhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:37:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 01 Feb 2012 09:37:36 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 1 Feb 2012 09:37:36 -0800
Subject: RE: [PATCH] pinctrl: delete raw device pointers in pinmux maps
Thread-Topic: [PATCH] pinctrl: delete raw device pointers in pinmux maps
Thread-Index: AczhBmCR9jmyfEofQIWHaICJOv6mGAAAYbPg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178E12470D@HQMAIL01.nvidia.com>
References: <1328117053-27807-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1328117053-27807-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Wednesday, February 01, 2012 10:24 AM:
> After discussion with Mark Brown in an unrelated thread about
> ADC lookups, it came to my knowledge that the ability to pass
> a struct device * in the regulator consumers is just a
> historical artifact, and not really recommended. Since there
> are no in-kernel users of these pointers, we just kill them
> right now, before someone starts to use them.
> 
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

I didn't review the code, but just wanted to note that
Documentation/pinctrl.txt needs some updates too, e.g. "Pinmux
board/machine configuration" says:

> As you can see we may have several pin controllers on the system and thus
> we need to specify which one of them that contain the functions we wish
> to map. The map can also use struct device * directly, so there is no
> inherent need to use strings to specify .dev_name or .ctrl_dev_name, these
> are for the situation where you do not have a handle to the struct device *,
> for example if they are not yet instantiated or cumbersome to obtain.

I'm fine with that being a separate patch if you want, or squashing
together two separate patches.

-- 
nvpublic

