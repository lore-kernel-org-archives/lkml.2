Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab0KZCpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 21:45:15 -0500
Received: from xenotime.net ([72.52.115.56]:46013 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752975Ab0KZCpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 21:45:14 -0500
Date: Thu, 25 Nov 2010 18:45:13 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 25 (snd/soc/codecs)
Message-Id: <20101125184513.fdb20279.rdunlap@xenotime.net>
In-Reply-To: <20101125164929.3a719716.sfr@canb.auug.org.au>
References: <20101125164929.3a719716.sfr@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Nov 2010 16:49:29 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101124:


When CONFIG_I2C is not enabled:

sound/soc/codecs/wm8737.c:521:error: 'i2c_master_send' undeclared (first use in this function)

but CONFIG_SND_SOC_I2C_AND_SPI=m
and CONFIG_SND_SOC_WM8737=m

Should SND_SOC_I2C_AND_SPI depend on I2C && SPI ??

config SND_SOC_I2C_AND_SPI
	tristate
	default m if I2C=m
	default y if I2C=y
	default y if SPI_MASTER=y


This doesn't handle the I2C disabled case, hence the build error.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
