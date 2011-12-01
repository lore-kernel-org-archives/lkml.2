Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1LAVom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:44:42 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17061 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab1LAVol convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:44:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 01 Dec 2011 13:44:37 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 1 Dec 2011 13:44:36 -0800
Subject: RE: [PATCH 1/2 v5] pinctrl: add a pin config interface
Thread-Topic: [PATCH 1/2 v5] pinctrl: add a pin config interface
Thread-Index: AcywF7fv9LE6eFxIRxS7CdNDwT61VgAWWjZw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174FDB0304@HQMAIL01.nvidia.com>
References: <1322736891-11262-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1322736891-11262-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Thursday, December 01, 2011 3:55 AM:
> This add per-pin and per-group pin config interfaces for biasing,
> driving and other such electronic properties. The details of passed
> configurations are passed in an opaque unsigned long which may be
> dereferences to integer types, structs or lists on either side
> of the configuration interface.
...

I'd still love to see separate param/value parameters to all the public
APIs as I mentioned elsewhere, but in the interests of moving things
forward:

Acked-by: Stephen Warren <swarren@nvidia.com>

> +extern int pin_config_get(struct pinctrl_dev *pctldev, int pin,
> +			  unsigned long *config);
> +extern int pin_config_set(struct pinctrl_dev *pctldev, int pin,
> +			  unsigned long config);

Should the per-pin APIs take a pin name (char*) instead of a pin number
just like the per-group APIs? That seems more consistent. Currently, only
the pinctrl core -> driver API ever deals with pin numbers, and e.g. the
mapping table only deals with names.

> +extern int pin_config_group_get(struct pinctrl_dev *pctldev,
> +				const char *pin_group,
> +				unsigned long *config);
> +extern int pin_config_group_set(struct pinctrl_dev *pctldev,
> +				const char *pin_group,
> +				unsigned long config);

-- 
nvpublic

