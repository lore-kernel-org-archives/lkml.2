Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab1GAQJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:09:30 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:6191 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab1GAQJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:09:28 -0400
Date: Fri, 1 Jul 2011 18:09:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Wolfe <cwolfe@chromium.org>
Cc: Alan Cox <alan@linux.intel.com>, Nathan Royer <nroyer@invensense.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 11/11] misc: Add slave driver for bma085 pressure sensor
Message-ID: <20110701180903.0fa2cbc9@endymion.delvare>
In-Reply-To: <20110701154150.0ac303a3@lxorguk.ukuu.org.uk>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
	<1309486707-1658-11-git-send-email-nroyer@invensense.com>
	<20110701085604.0aabd6f1@bob.linux.org.uk>
	<CAN_12A8Za7r92=r3JHx3R=AwAA7xk6=NVVMiSp68HPatb1G3hg@mail.gmail.com>
	<20110701154150.0ac303a3@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jul 2011 15:41:50 +0100, Alan Cox wrote:
> > Just to field this quickly, since I've been playing with the hardware
> 
> (Ditto)
> 
> > Part of the reason I got started on the KXTF9 driver was to try and
> > understand how a normal kernel driver could cope with the "here and
> > gone again" behavior of being on the MPU's secondary bus.
> 
> It's a hot pluggable bus - no different to an i2c bus on a hot pluggable
> device. 
> 
> I would guess however that if you knew the device was going to be used for
> the mpu3050 only you'd not add the "slave" devices in your platform data
> in the first place as well so they didn't bounce in and out and you'd
> probably teach the mpu3050 code to not create the bus if it was then
> going to destroy it again a moment later.

I didn't look in the code in details, but I see no reason to destroy
buses. This is a standard multi-master case, where a given I2C bus
segment can be driven by two masters. If both the host I2C controller
and the MPU3050 master are fully I2C compliant, it should be no problem
to let both coexist. If you really need to handle mutual exclusion
(e.g. the MPU3050 implementation forces you to do so), you can leverage
the i2c multiplexing support for this, which is available since kernel
2.6.36. See drivers/i2c/muxes/pca9541.c for an example implementation.

-- 
Jean Delvare
