Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1GAHxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 03:53:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:1620 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925Ab1GAHxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 03:53:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,456,1304319600"; 
   d="scan'208";a="25095039"
Date: Fri, 1 Jul 2011 08:53:16 +0100
From: Alan Cox <alan@linux.intel.com>
To: Nathan Royer <nroyer@invensense.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 01/11] misc: inv_mpu primary header file and README
 file.
Message-ID: <20110701085316.00fcc8bd@bob.linux.org.uk>
In-Reply-To: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1) Is there a master design or standard interface for Motion
> Processing devices, specifically ones that do calibration, sensor
> fusion, and or have a micro-controller to do some of this work.

Not specifically - but for the most part it shouldn't matter. We have
interfaces like request_firmware() to load firmware and we have
interfaces for input devices and for 

> 2) Is there a standard way to integrate user space components with
> kernel side components.

Use the standard kernel interfaces. If specific processing is needed in
user space the to go into the kernel it needs to be such that those
interfaces can be used in an open manner (this normally comes up with
3D graphics hardware rather than input), either by documenting the
interface or providing an open implementation.

> 3) Should data be pushed back to the driver from userspace, and made
> available as an input device or should it remain as a character
> device. 

The ektf2136 driver currently getting tidied up provides both. You can
open it either as an input driver directly, or you can access raw event
data in a documented for and do clever things with the data and feed it
back to the input layer via uevent.

> 6) Are there any other major design concerns? 

We have an initial mpu3050 driver which provides basic functionality
(from Wistron/Intel), normal Linux practice would be to extend and
improve that.

> 7) Can an input device also have a character device interface for
> proprietary customization.

That depends what you mean and what for. Fundamentally there is no
reason a device cannot present multiple interfaces although you might
need to lock between them.

> +Programming the chip using /dev/mpu
> +----------------------------------
> +Programming of MPU3050 is done by first opening the /dev/mpu file and
> +then performing a series of IOCTLS on the handle returned.  The
> IOCTL codes can +be found in mpu.h.  Typically this is done by the
> mllite library in user +space.

Is this published with source or sufficient documentation for someone
to write their own ? Note btw the usual expectation would be that the
kernel driver uses request_firmware to load firmware as needed for that
part of the process.

