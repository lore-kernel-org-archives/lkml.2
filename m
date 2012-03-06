Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031340Ab2CFWQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:16:38 -0500
Received: from [91.198.169.23] ([91.198.169.23]:56131 "EHLO csmtp3.one.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1030811Ab2CFWQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:16:37 -0500
Date: Tue, 6 Mar 2012 23:17:52 +0100
From: Eric Andersson <eric.andersson@unixphere.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, zhengguang.guo@bosch-sensortec.com,
        peter.moeller@cn.bosch.com,
        Stefan Nilsson <stefan.nilsson@unixphere.com>
Subject: Re: [PATCHv2 2/3] misc: add support for bmp18x chips to the bmp085
 driver
Message-ID: <20120306221752.GB18235@skinner.xfiles.lan>
References: <1331068084-17911-1-git-send-email-eric.andersson@unixphere.com>
 <1331068084-17911-3-git-send-email-eric.andersson@unixphere.com>
 <201203062127.44463.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203062127.44463.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21:27 Tue 06 Mar     , Arnd Bergmann wrote:
> On Tuesday 06 March 2012, Eric Andersson wrote:
> > The bmp18x chip family comes in an I2C respectively SPI variant.
> > Hence, the bmp085 driver was split to support both buses.
> > 
> > Tested-by: Zhengguang Guo <zhengguang.guo@bosch-sensortec.com>
> > Reviewed-by: Stefan Nilsson <stefan.nilsson@unixphere.com>
> > Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>
> 
> (adding Mark Brown to Cc)
> 
> I don't know much about regmap, but your description sounds like you
> should be using it here, to simplify the differences between i2c and
> spi in your driver instead of implementing your own abstraction
> layer.
> 
> >  config BMP085
> >  	tristate "BMP085 digital pressure sensor"
> > -	depends on I2C && SYSFS
> > +	depends on (I2C || SPI_MASTER) && SYSFS
> >  	help
> > -	  If you say yes here you get support for the Bosch Sensortec
> > -	  BMP085 digital pressure sensor.
> > +	  Say Y here if you want support for Bosch Sensortec's digital
> > +	  pressure sensors BMP085 and BMP18x.
> >  
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called bmp085.
> >  
> > +config BMP085_I2C
> > +	tristate "support I2C bus connection"
> > +	depends on BMP085 && I2C
> > +	help
> > +	  Say Y here if you want to support Bosch Sensortec's digital pressure
> > +	  sensor hooked to an I2C bus.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called bmp085-i2c.
> > +
> > +config BMP085_SPI
> > +	tristate "support SPI bus connection"
> > +	depends on BMP085 && SPI_MASTER
> > +	help
> > +	  Say Y here if you want to support Bosch Sensortec's digital pressure
> > +	  sensor hooked to an SPI bus.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called bmp085-spi.
> > +
> 
> IMHO this would be better expressed if you make CONFIG_BMP085 a hidden
> option that is selected when either BMP085_I2C or BMP085_SPI are enabled.
> Otherwise you make it possible to build just the base driver but neither
> of the front-ends, which is a bit pointless.

This setup is inspired from other drivers such as ad525x_dpot.c and
ad714x.c, which also have their own bus abstraction. If regmap is a more
generic way of solving this I am all for it!

-- 
Best regards,
 Eric

http://www.unixphere.com
