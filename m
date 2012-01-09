Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab2AIHLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:11:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50370 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754529Ab2AIHLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:11:51 -0500
Date: Sun, 8 Jan 2012 23:11:29 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Laxman Dewangan <ldewangan.com@nvidia.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH V1] TPS62360: Add tps62360 regulator driver
Message-ID: <20120109071128.GA22134@opensource.wolfsonmicro.com>
References: <1325668818-1096-1-git-send-email-ldewangan@nvidia.com>
 <20120105062919.GI11867@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9E9B@BGMAIL01.nvidia.com>
 <20120106185755.GC2893@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0DE@BGMAIL01.nvidia.com>
 <20120107191047.GA3590@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0E4@BGMAIL01.nvidia.com>
 <20120108165819.GB29065@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9A3@BGMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9A3@BGMAIL01.nvidia.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 12:34:25PM +0530, Laxman Dewangan wrote:

> In my design, the voltage vary from 900mV to the 1300mV in increment of
> 50mV. In this case, the voltage change request is 900, 950, 1000, 1050,
> 1100, 1150, 1200, 1250, 1300.
> I would like to have entry like
> 900-950->vsel0
> 950-1000>vsel1,
> 1000-1050->vsel2
> 1050-1100->vsel3
> 1100-1150->vsel0
> 1150-1200->vsel1
> 1200-1250->vsel2
> 1250->1300->vsel3

Why?  I'm not sure I understand this.  You're asking the regulator to
output ranges not voltages and you're setting multiple overlapping
ranges for each VSEL.

> Based on voltage increment requirements for a given application, this
> table can be tune more. Now if client request for voltage setting for
> range of 1000-1050, I will select the VSET1 for configuration, similarly
> for 1100-1150, VSET0 will be the configuration register.

This just seems like it makes the driver configuration much more
complex and restricts the ability of the system to adapt itself to
what's happening at runtime.

What I'd expect to see is nothing but the GPIOs and their default state
(since sadly we can't read back from output GPIOs with gpiolib) being
specified.
