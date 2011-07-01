Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab1GAO3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:29:00 -0400
Received: from smtp-out.google.com ([74.125.121.67]:15116 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab1GAO27 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:28:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=l/qQnjLBBQ4yg6ZVn0B9b2j4xaZbtkh/QXwQfHCGCfWYF/xJ0Itrin2+HG1YHgHZI
	QyL3jybwP9k0xEMx8Pcpg==
MIME-Version: 1.0
In-Reply-To: <20110701085604.0aabd6f1@bob.linux.org.uk>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
	<1309486707-1658-11-git-send-email-nroyer@invensense.com>
	<20110701085604.0aabd6f1@bob.linux.org.uk>
Date: Fri, 1 Jul 2011 07:28:53 -0700
X-Google-Sender-Auth: 1Bo6-hugeJtwp0OPCVtjjMpVxtA
Message-ID: <CAN_12A8Za7r92=r3JHx3R=AwAA7xk6=NVVMiSp68HPatb1G3hg@mail.gmail.com>
Subject: Re: [PATCH 11/11] misc: Add slave driver for bma085 pressure sensor
From: Chris Wolfe <cwolfe@chromium.org>
To: Alan Cox <alan@linux.intel.com>
Cc: Nathan Royer <nroyer@invensense.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 12:56 AM, Alan Cox <alan@linux.intel.com> wrote:
> The slave devices all appear to be generic i2c interface hardware. I
> don't see why they are separate special slave devices to your driver,
> they should simply be i²c drivers so they can be used when those
> devices are found without the mpu3050.

Just to field this quickly, since I've been playing with the hardware
involved. There are actually two different things handled by the
"slave devices".

The MPU-3050 (and some similar InvenSense parts) provide a secondary
I2C bus. By default this is passed through to the I2C bus on which the
3050 is installed, but the MPU can also detach the extra bus and act
as an I2C master on it. A slave device is connected on this extra bus,
configured normally by the kernel, and then taken over by the MPU
(which will periodically do a block read of a configured address).

The second case of a slave device is simply some other device that the
driver reads from, and passes the data to the MPU for processing.

Part of the reason I got started on the KXTF9 driver was to try and
understand how a normal kernel driver could cope with the "here and
gone again" behavior of being on the MPU's secondary bus.

The other note that may not have been made explicit yet is that the
3050 will happily provide unprocessed gyro and slave data without
firmware loaded. The firmware sets up some additional processing
capabilities of the chip, which are used by InvenSense's user-space
products.

Chris

[Sorry about gmail. I'm on the road and hope it doesn't mangle things
too badly.]
