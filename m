Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab2IALOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 07:14:33 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39442 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753365Ab2IALOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 07:14:31 -0400
MIME-Version: 1.0
In-Reply-To: <1345643359-16584-1-git-send-email-stigge@antcom.de>
References: <1345643359-16584-1-git-send-email-stigge@antcom.de>
Date: Sat, 1 Sep 2012 16:44:29 +0530
Message-ID: <CAPub14-Oot_wJsRTv2AGu3SAAf40+3_wK43=0Swxj+5XjPaDew@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] spi/pl022: Add chip select handling via GPIO
From: shiraz hashim <shiraz.linux.kernel@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: linus.walleij@linaro.org, aletes.xgr@gmail.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        gabriel.fernandez@stericsson.com, lee.jones@linaro.org,
        viresh.kumar@linaro.org, sachin.verma@st.co
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

On Wed, Aug 22, 2012 at 7:19 PM, Roland Stigge <stigge@antcom.de> wrote:
> @@ -2016,6 +2030,8 @@ pl022_probe(struct amba_device *adev, co
>         pl022->master_info = platform_info;
>         pl022->adev = adev;
>         pl022->vendor = id->data;
> +       /* Point chipselects to allocated memory beyond the main struct */
> +       pl022->chipselects = (int *) pl022 + sizeof(struct pl022);

This is going beyond memory allocated for chipselects
as it adds 4 * sizeof(struct pl022) bytes to pl022.

pl022->chipselects = (int *) &pl022[1];
can be musch safer.

-- 
regards
Shiraz Hashim
