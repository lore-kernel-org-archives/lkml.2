Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab0JKRj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:39:58 -0400
Received: from kroah.org ([198.145.64.141]:52353 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524Ab0JKRj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:39:57 -0400
Date: Mon, 11 Oct 2010 10:36:49 -0700
From: Greg KH <greg@kroah.com>
To: Minkyu Kang <mk7.kang@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, kyungmin.park@samsung.com,
        Ben Dooks <ben-i2c@fluff.org>
Subject: Re: [PATCH v2] misc: adds support the FSA9480 USB Switch
Message-ID: <20101011173649.GC7116@kroah.com>
References: <4C7CD95A.5040309@samsung.com> <20100917150731.f1f44f3c.akpm@linux-foundation.org> <AANLkTim2UhJAhOw1qHvZ9bbctR0tNSMvE61T=sxffHxO@mail.gmail.com> <4CB26931.5040105@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB26931.5040105@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 10:32:33AM +0900, Minkyu Kang wrote:
> The FSA9480 is a USB port accessory detector and switch.
> This patch adds support the FSA9480 USB Switch.
> 
> Signed-off-by: Minkyu Kang <mk7.kang@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> v2:
>  use the threaded irq
>  fix the sysfs
> 
>  drivers/misc/Kconfig    |    9 +
>  drivers/misc/Makefile   |    1 +
>  drivers/misc/fsa9480.c  |  544 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fsa9480.h |   40 ++++

Why do you need a .h file here for a single driver?

You are creating new sysfs files, so you are required to add a new
Documentation/ABI file as well, please add that to this patch.

And why are you exporting symbols from this driver, that should not be
needed at all.


> +/*
> + * fsa9480.c - FSA9480 micro USB switch device driver
> + *
> + * Copyright (C) 2010 Samsung Electronics
> + * Minkyu Kang <mk7.kang@samsung.com>
> + * Wonguk Jeong <wonguk.jeong@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.

Are you positive about that "any later version" portion of this?

thanks,

greg k-h
