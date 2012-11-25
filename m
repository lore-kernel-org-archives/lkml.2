Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab2KYXO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 18:14:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:31167 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633Ab2KYXO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 18:14:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,316,1352102400"; 
   d="scan'208";a="252314261"
Date: Mon, 26 Nov 2012 00:14:07 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        David Dajun Chen <dchen@diasemi.com>
Subject: Re: [Patch v1 1/1] mfd: fix for i2c issue DA9052/53 PMIC
Message-ID: <20121125231407.GK12685@sortiz-mobl>
References: <1351853246.32389.8.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351853246.32389.8.camel@dhruva>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

On Fri, Nov 02, 2012 at 04:17:26PM +0530, Ashish Jangam wrote:
> There is an issue where the DA9052/53-AA/BA/BB PMIC either locks up or fails to
> respond following a system Reset. This could result in a second write
> in which the bus writes the current content of the write buffer to address
> of the last I2C access.
> 
> The failure case is where this unwanted write transfers incorrect data to
> a critical register.
> 
> This patch fixes this issue by following any read or write with a dummy read
> to a safe register address. A safe register address is one where the contents
> will not affect the operation of the system.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
>  drivers/mfd/da9052-i2c.c          |   56 +++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/da9052/da9052.h |   47 ++++++++++++++++++++++++++++--
>  include/linux/mfd/da9052/reg.h    |    3 ++
>  3 files changed, 102 insertions(+), 4 deletions(-)
Applied to my for-linus branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
