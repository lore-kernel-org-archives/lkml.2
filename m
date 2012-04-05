Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab2DEGaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 02:30:19 -0400
Received: from csmtp2.one.com ([91.198.169.22]:10790 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189Ab2DEGaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 02:30:17 -0400
Date: Thu, 5 Apr 2012 08:30:56 +0200
From: Eric Andersson <eric.andersson@unixphere.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, arnd@arndb.de,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        stefan.nilsson@unixphere.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCHv3 1/3] misc: clean up bmp085 driver
Message-ID: <20120405063056.GA7135@skinner.xfiles.lan>
References: <1333568759-13536-1-git-send-email-eric.andersson@unixphere.com>
 <1333568759-13536-2-git-send-email-eric.andersson@unixphere.com>
 <1333569359.23520.12.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333569359.23520.12.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On 12:55 Wed 04 Apr     , Joe Perches wrote:
> On Wed, 2012-04-04 at 21:45 +0200, Eric Andersson wrote:
> > This patch includes various cleaning of the bmp085 driver including:
> > - Whitespaces and alignment fixes
> > - Minor typos
> > - Consistency fixes
> 
> just some more trivial things:
> 
> > diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
> []
> > @@ -222,8 +217,10 @@ exit:
> >  /*
> >   * This function starts the pressure measurement and returns the value
> >   * in millibar. Since the pressure depends on the ambient temperature,
> > - * a temperature measurement is executed if the last known value is older
> > - * than one second.
> > + * a temperature measurement is executed according to the given temperature
> > + * measurememt period (default is 1 sec boundary). This period could vary
> 
> typo: measurement
> 
> > + * and needs to be adjusted according to the sensor environment, i.e. if big
> > + * temperature variations then the temperature needs to be read out often.
> 
> > @@ -386,25 +387,23 @@ static int bmp085_detect(struct i2c_client *client, struct i2c_board_info *info)
> >  
> >  static int bmp085_init_client(struct i2c_client *client)
> []
> > -	dev_info(&data->client->dev, "BMP085 ver. %d.%d found.\n",
> > -			(version & 0x0F), (version & 0xF0) >> 4);
> 
> Why remove the "version" output?

The version register is actually not an official register and is subject to
change in the future.

I'll fix the typos in next version!

Thanks!

-- 
Best regards,
 Eric

http://www.unixphere.com
