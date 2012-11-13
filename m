Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab2KMSzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:55:44 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:14550 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab2KMSzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:55:42 -0500
Date: Tue, 13 Nov 2012 19:55:33 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Till Harbaum <till@harbaum.org>
Subject: Re: [PATCH 1/2] i2c: Add possibility for user-defined (i2c-)devices
 for bus-drivers.
Message-ID: <20121113195533.6db71716@endymion.delvare>
In-Reply-To: <1352829968-4908-1-git-send-email-holler@ahsoftware.de>
References: <1352829968-4908-1-git-send-email-holler@ahsoftware.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012 19:06:07 +0100, Alexander Holler wrote:
> This makes it possible to define i2c-devices at the kernel command line
> or as a module parameter for bus-drivers which want to offer such
> an functionality.
> 
> Drivers which are using it will have the a parameter named
> devices with format devname1@addr1,devname2@addr2,...
> e.g. devices=ds1307@0x68,pcf8563@0x51

No, no, no. We did that 10 years ago, killed all the code 3 years ago
[1], let's not do the same mistake again, please. We have a sysfs
interface for instantiating clients dynamically from user-space, it's
way more powerful and flexible than your proposal. Just try plugging two
different i2c-tiny-usb adapters on the same system and see the new code
instantiate the wrong devices...

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=7f508118b1c1f9856a1c899a2bd4867a962b0225

> The devices will be probed using the standard probe mechanism,
> the definition of up to 8 devices is allowed.
> 
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Till Harbaum <till@harbaum.org>
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---
>  Documentation/i2c/instantiating-devices | 37 ++++++++++++++++++++++++++++++
>  drivers/i2c/i2c-core.c                  | 40 +++++++++++++++++++++++++++++++++
>  include/linux/i2c.h                     | 14 ++++++++++++
>  3 files changed, 91 insertions(+)
> (...)

-- 
Jean Delvare
