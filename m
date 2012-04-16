Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab2DPHGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 03:06:30 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9665 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2DPHG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 03:06:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 16 Apr 2012 00:06:29 -0700
Message-ID: <4F8BC20A.2090105@nvidia.com>
Date: Mon, 16 Apr 2012 12:24:02 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH] mfd: fix modular builds of rc5t583 regulator support
References: <1334549301-32114-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1334549301-32114-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 April 2012 09:38 AM, Paul Gortmaker wrote:
> The combination of commit 1b1247dd75aa5cf5fae54a3bec7280046e9c7957
>
>      "mfd: Add support for RICOH PMIC RC5T583"
>
> and commit 6ffc3270210efa2bea526953a142ffc908f5bd86
>
>      "regulator: Add support for RICOH PMIC RC5T583 regulator"
>
> are causing the i386 allmodconfig builds to fail with this:
>
>    ERROR: "rc5t583_update" [drivers/regulator/rc5t583-regulator.ko] undefined!
>    ERROR: "rc5t583_set_bits" [drivers/regulator/rc5t583-regulator.ko] undefined!
>    ERROR: "rc5t583_clear_bits" [drivers/regulator/rc5t583-regulator.ko] undefined!
>    ERROR: "rc5t583_read" [drivers/regulator/rc5t583-regulator.ko] undefined!
>
> and this:
>
>    ERROR: "rc5t583_ext_power_req_config" [drivers/regulator/rc5t583-regulator.ko] undefined!
>
> For the 1st four, make the simple ops static inline, instead of
> polluting the namespace with trivial exports.  For the last one,
> add an EXPORT_SYMBOL.
>
> Signed-off-by: Paul Gortmaker<paul.gortmaker@windriver.com>
> ---
>
> [ alternately, make REGULATOR_RC5T583 bool instead of tristate? ]

Why not export all require symbol from mfd core.
I am sending the patch to exporting all required apis. Please review.
