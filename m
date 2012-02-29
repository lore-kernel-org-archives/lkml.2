Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab2B2V1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 16:27:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62288 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2B2V1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 16:27:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH 0/3] Replace bmp085 with bmp18x
Date: Wed, 29 Feb 2012 21:26:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Eric Andersson <eric.andersson@unixphere.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        christoph.mair@gmail.com, stefan.nilsson@unixphere.com,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        Jonathan Cameron <jic23@cam.ac.uk>
References: <1330545489-31169-1-git-send-email-eric.andersson@unixphere.com> <201202292018.45557.arnd@arndb.de> <20120229203743.GA21671@elliptictech.com>
In-Reply-To: <20120229203743.GA21671@elliptictech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202292126.56083.arnd@arndb.de>
X-Provags-ID: V02:K0:Ts9t0SZJFTwEskEEU6afqr61fE3W/mkMVZJpqhcxQ6y
 orWpSX0JeEfNANSejHWr76Y4FNGS/eZrYq9fmM1GXewNTB71Un
 ybSDijbS+3Ea+e04GbwI+dXoaqCp8aUL1WzC3qJN3TTg0Q//Cj
 4zZYx0ZDYsZML77kKztBQALp5kmWejAGjKDyTEi49g/Y1Kev9k
 ktRsxLiDRnFLT6Op4fhMMzDHoMyc1f1oAJz9AV4pZzJ1+2kYMI
 qcqAFd2JO+ebMRHu4oSy4yl5Iux6fOC7DcDGaJ6Q4QDMY7u047
 VOe9vR45HOn6aTurCoviiitgYrZRyPGIiYKeGic1TacO+bpmOG
 WTLq03cM5pS7t0gw1J+A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 February 2012, Nick Bowler wrote:
> On 2012-02-29 20:18 +0000, Arnd Bergmann wrote:
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
> 
> Notwithstanding the value of using newer generic interfaces, from what I
> can tell, there are no new sysfs attributes added by this driver over
> the one it replaces.  If this driver is going to supersede the old one,
> it has to retain the existing interface.  Otherwise, we must keep both
> drivers in the tree to avoid regressions.

Well, the driver is presented as a new one ;-)

I also think it would be nicer generally speaking to do this as incremental
updates, which could be as simple as

1. code cleanups in bmp085 without functional changes
2. add support for bmp18x
3. rename bmp085 to bmp18x, with no other changes

That would take care of the argument of adding a new driver with the "wrong"
interface as well as make the history of that driver cleaner, e.g. for
purposes of walking through the patches using 'git log --follow'.

> > Why is this not using IIO for its user interface?
> 
> Because IIO is currently in staging, and this driver is not?

Yes, this is of course a big limitation still and I agree that we
cannot hold up progress on drivers that don't use it yet.

	Arnd
