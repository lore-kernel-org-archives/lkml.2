Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1BWAVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 19:21:04 -0500
Received: from trinity.fluff.org ([89.16.178.74]:39225 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab1BWAVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 19:21:01 -0500
Date: Wed, 23 Feb 2011 00:20:59 +0000
From: Ben Dooks <ben-i2c@fluff.org>
To: Colin Cross <ccross@android.com>
Cc: Ben Dooks <ben-i2c@fluff.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
        swarren@nvidia.com, patches@opensource.wolfsonmicro.com,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] i2c: tegra: Add i2c support
Message-ID: <20110223002059.GV15795@trinity.fluff.org>
References: <AANLkTim0X=gUwYJmR+EAYjGamiJb7tgiVEjwqCEF0-L0@mail.gmail.com> <1298250861-27094-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298250861-27094-1-git-send-email-ccross@android.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 05:14:21PM -0800, Colin Cross wrote:
> Adds I2C bus driver for nVidia Tegra SoCs.  Tegra includes 4 I2C
> controllers, one of which is inside the Dynamic Voltage Controller
> and has a slightly different register map.
> 
> Signed-off-by: Colin Cross <ccross@android.com>

Would have been helpful to start a new thread, missed this the first time
around.

> +	i2c_dev = kzalloc(sizeof(struct tegra_i2c_dev), GFP_KERNEL);
> +	if (!i2c_dev) {

no error print here.

> +		ret = -ENOMEM;
> +		goto err_i2c_clk_put;
> +	}

> +	if (pdev->id == 3)
> +		i2c_dev->is_dvc = 1;
> +	init_completion(&i2c_dev->msg_complete);

you might want to think about having a seperate platform bus name for
this case, and switching the is_dvc field on that. It'll make life much
easier if someone decides that what the next tegra i2c needs is 5 i2c
controllers.

I'll consider putting this (as is) into the -next tree, but would like
to see the issues with readsl/writesl sorted out and any other review
comments sorted.

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

