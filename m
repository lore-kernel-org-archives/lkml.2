Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab0KZLVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:21:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43208 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754900Ab0KZLVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:21:48 -0500
Date: Fri, 26 Nov 2010 11:21:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 25 (snd/soc/codecs)
Message-ID: <20101126112145.GA30360@rakim.wolfsonmicro.main>
References: <20101125164929.3a719716.sfr@canb.auug.org.au>
 <20101125184513.fdb20279.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101125184513.fdb20279.rdunlap@xenotime.net>
X-Cookie: Sentient plasmoids are a gas.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 06:45:13PM -0800, Randy Dunlap wrote:

> config SND_SOC_I2C_AND_SPI
> 	tristate
> 	default m if I2C=m
> 	default y if I2C=y
> 	default y if SPI_MASTER=y

> This doesn't handle the I2C disabled case, hence the build error.

It does, anything with this configuration should have appropriate ifdefs
to cover it, it's just that one is missed here.  The purpose of the
symbol is to ensure we don't try to build one of these drivers into the
kernel when I2C is modular.
