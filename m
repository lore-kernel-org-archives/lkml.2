Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab1HSVEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:04:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47799 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752532Ab1HSVEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:04:34 -0400
Date: Fri, 19 Aug 2011 17:04:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Per Forlin <per.forlin@linaro.org>
cc: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-dev@lists.linaro.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v6] usb: gadget: storage: make FSG_NUM_BUFFERS variable
 size
In-Reply-To: <1313781687-13955-1-git-send-email-per.forlin@linaro.org>
Message-ID: <Pine.LNX.4.44L0.1108191703480.3500-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011, Per Forlin wrote:

> FSG_NUM_BUFFERS is set to 2 as default.
> Usually 2 buffers are enough to establish a good buffering pipeline.
> The number may be increased in order to compensate a for bursty VFS
> behaviour.
> 
> Here follows a description of system that may require more than
> 2 buffers.
>  * CPU ondemand governor active
>  * latency cost for wake up and/or frequency change
>  * DMA for IO
> 
> Use case description.
>  * Data transfer from MMC via VFS to USB.
>  * DMA shuffles data from MMC and to USB.
>  * The CPU wakes up every now and then to pass data in and out from VFS,
>    which cause the bursty VFS behaviour.
> 
> Test set up
>  * Running dd on the host reading from the mass storage device
>  * cmdline: dd if=/dev/sdb of=/dev/null bs=4k count=$((256*100))
>  * Caches are dropped on the host and on the device before each run
> 
> Measurements on a Snowball board with ondemand_governor active.
> 
> FSG_NUM_BUFFERS 2
> 104857600 bytes (105 MB) copied, 5.62173 s, 18.7 MB/s
> 104857600 bytes (105 MB) copied, 5.61811 s, 18.7 MB/s
> 104857600 bytes (105 MB) copied, 5.57817 s, 18.8 MB/s
> 
> FSG_NUM_BUFFERS 4
> 104857600 bytes (105 MB) copied, 5.26839 s, 19.9 MB/s
> 104857600 bytes (105 MB) copied, 5.2691 s, 19.9 MB/s
> 104857600 bytes (105 MB) copied, 5.2711 s, 19.9 MB/s
> 
> There may not be one optimal number for all boards. This is why
> the number is added to Kconfig. If selecting USB_GADGET_DEBUG_FILES
> this value may be set by a module parameter as well.
> 
> Signed-off-by: Per Forlin <per.forlin@linaro.org>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

