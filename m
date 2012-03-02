Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab2CBQta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 11:49:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62734 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758860Ab2CBQt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 11:49:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 0/3] Replace bmp085 with bmp18x
Date: Fri, 2 Mar 2012 16:49:17 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Eric Andersson <eric.andersson@unixphere.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        christoph.mair@gmail.com, stefan.nilsson@unixphere.com,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        Jonathan Cameron <jic23@cam.ac.uk>
References: <1330545489-31169-1-git-send-email-eric.andersson@unixphere.com> <201202292018.45557.arnd@arndb.de> <20120229235217.494d49d8@pyramind.ukuu.org.uk>
In-Reply-To: <20120229235217.494d49d8@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203021649.18156.arnd@arndb.de>
X-Provags-ID: V02:K0:BC9SywnGQToVg+GF+/76JvIFBbj0Ul1w53VxD6d007a
 vpsIh8PDAxwhP7XTTKkTSMgFSy6cgPmMNWlkSmqjAQhewh9V1n
 +I9anCmFkaHIPYgU9+2enYhtNNtx3bnc8rotiFaI7H4k0MV9OL
 Vzs/+ATE82aUE/qSNQrew8KpUCRpkInt7FsRMgixCagQSx7Dsx
 Cp6wkYH08G+I/tB4ZgbvhrsdWRIUYVUhlrtWGCGbhrVJy3qICh
 U7tlZff3o4m/1ivXl599DiIiLGlF0azLKCUu0reu31hrLV1Sli
 1+D4R46X9p22h28Z005wVB3mDghW1MUYqpVigI9Qz9V6vXErgv
 dO9lk2QnSmNkF9F5TuyQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 February 2012, Alan Cox wrote:
> On Wed, 29 Feb 2012 20:18:45 +0000
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Wednesday 29 February 2012, Eric Andersson wrote:
> > > This patch-set replaces the BMP085 driver with a driver for Bosch Sensortec's new
> > > generation of pressure sensors called BMP18x. These pressure sensors can be
> > > connected on I2C but also on SPI as a variant, so the driver implements both.
> > > Register-wise they are fully compatible with the older BMP085, so the driver will
> > > support those chips as well.
> > > 
> > > The driver is based on bmp085.c by Christoph Mair.
> > 
> > Hmm,  the implementation looks fine, but I don't think we should add support
> > for new devices with a one-off interface that we know is getting replaced by
> > something generic.
> > 
> > Why is this not using IIO for its user interface?
> 
> This is become a repeating problem
> 
> Either get the IIO layer out of staging (where it appears to have
> congealed) or stop asking people to use it. IIO stuck in staging is
> becoming a problem not a cure. It's creating uncertainty blocking lots of
> stuff that needs to get upstream and that current stream is going to
> become a tide post Android merging.
> 
> It needs resolving one way or the other and soon.

Yes, that is probably true. It has been looking like we are closing in
on merging IIO for some time now, but I'm not sure how well it's going
recently. In November, Jonathan mentioned that he is busy with other
things and that he would welcome other people to help out. There were
patches to move parts of IIO out of staging, but I'm not completely
sure how far they have come.

In case of bmp085 I don't see much of a problem and I was probably
overreacting as this is an existing driver.

Unfortunately, I'm not sure if there is any reasonable alternative
to iio for new device drivers: If we get a flood of new drivers for
all sorts of sensors that each have their own user interface,
someone still needs to review all those interfaces and come up
with infrastucture to reduce the amount of code duplication and
interface differences between the drivers. IIO was promising to
do just that, and it has come a long way since it was initially
included into staging. 

	Arnd
