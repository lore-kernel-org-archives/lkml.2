Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab2B2Uhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:37:47 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:47957 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755467Ab2B2Uhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:37:46 -0500
Date: Wed, 29 Feb 2012 15:37:43 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Andersson <eric.andersson@unixphere.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        christoph.mair@gmail.com, stefan.nilsson@unixphere.com,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH 0/3] Replace bmp085 with bmp18x
Message-ID: <20120229203743.GA21671@elliptictech.com>
References: <1330545489-31169-1-git-send-email-eric.andersson@unixphere.com>
 <201202292018.45557.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202292018.45557.arnd@arndb.de>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-29 20:18 +0000, Arnd Bergmann wrote:
> On Wednesday 29 February 2012, Eric Andersson wrote:
> > This patch-set replaces the BMP085 driver with a driver for Bosch Sensortec's new
> > generation of pressure sensors called BMP18x. These pressure sensors can be
> > connected on I2C but also on SPI as a variant, so the driver implements both.
> > Register-wise they are fully compatible with the older BMP085, so the driver will
> > support those chips as well.
> > 
> > The driver is based on bmp085.c by Christoph Mair.
> 
> Hmm,  the implementation looks fine, but I don't think we should add support
> for new devices with a one-off interface that we know is getting replaced by
> something generic.

Notwithstanding the value of using newer generic interfaces, from what I
can tell, there are no new sysfs attributes added by this driver over
the one it replaces.  If this driver is going to supersede the old one,
it has to retain the existing interface.  Otherwise, we must keep both
drivers in the tree to avoid regressions.

> Why is this not using IIO for its user interface?

Because IIO is currently in staging, and this driver is not?

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

