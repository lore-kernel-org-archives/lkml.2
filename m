Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab2AIIth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 03:49:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39717 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686Ab2AIItd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 03:49:33 -0500
Date: Mon, 9 Jan 2012 00:48:46 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Laxman Dewangan <ldewangan.com@nvidia.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH V1] TPS62360: Add tps62360 regulator driver
Message-ID: <20120109084845.GA15277@opensource.wolfsonmicro.com>
References: <20120106185755.GC2893@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0DE@BGMAIL01.nvidia.com>
 <20120107191047.GA3590@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0E4@BGMAIL01.nvidia.com>
 <20120108165819.GB29065@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9A3@BGMAIL01.nvidia.com>
 <20120109071128.GA22134@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9B6@BGMAIL01.nvidia.com>
 <20120109073859.GG22134@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9D6@BGMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9D6@BGMAIL01.nvidia.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 02:17:17PM +0530, Laxman Dewangan wrote:
> > On Monday, January 09, 2012 1:09 PM, Mark Brown wrote

> > The driver can decide what voltages to set - like I said in a previous
> > mail it could use something like LRU to decide which slot to use, or
> > perhaps be clever with the upper end of the range it was given.

> So we will change the gpios output also according to voltage register
> slot from driver?

You'd need to change both from the driver.

> So through platform data, I will pass the gpio nr for VSEL0, VSEL1 and
> their default state. 

Yes.

> If valid gpios will be passed then driver will use the LRU mechanism
> for getting desired configuration register for configuring the desired
> voltage (passed through the regulator_setvoltage())and set the gpios
> accordingly through gpio libs.
> In this approach, because we need to set two different gpios for
> desired logic, the output will not go in proper transition from
> current to new one, for some time when we completed setting of
> one gpio and setting second gpio.

Isn't that an issue anyway?
