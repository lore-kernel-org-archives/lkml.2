Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2AIHjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:39:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49668 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754537Ab2AIHjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:39:09 -0500
Date: Sun, 8 Jan 2012 23:39:00 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Laxman Dewangan <ldewangan.com@nvidia.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH V1] TPS62360: Add tps62360 regulator driver
Message-ID: <20120109073859.GG22134@opensource.wolfsonmicro.com>
References: <20120105062919.GI11867@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9E9B@BGMAIL01.nvidia.com>
 <20120106185755.GC2893@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0DE@BGMAIL01.nvidia.com>
 <20120107191047.GA3590@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0E4@BGMAIL01.nvidia.com>
 <20120108165819.GB29065@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9A3@BGMAIL01.nvidia.com>
 <20120109071128.GA22134@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9B6@BGMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9B6@BGMAIL01.nvidia.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 01:03:06PM +0530, Laxman Dewangan wrote:
> > On Monday, January 09, 2012 12:41 PM, Mark Brown wrote

> > Why?  I'm not sure I understand this.  You're asking the regulator to
> > output ranges not voltages and you're setting multiple overlapping
> > ranges for each VSEL.

> If I fix the voltage with each VSEL then only 4 voltages will be
> possible but I want to have more than 4 different output.
> How do I achieve this?

The driver can decide what voltages to set - like I said in a previous
mail it could use something like LRU to decide which slot to use, or
perhaps be clever with the upper end of the range it was given.

> > What I'd expect to see is nothing but the GPIOs and their default state
> > (since sadly we can't read back from output GPIOs with gpiolib) being
> > specified.

> I did not understand it correctly. Can you please elaborate how can we
> pass the voltage with corresponding vsel?

For bootstrapping you can just read the values back.
