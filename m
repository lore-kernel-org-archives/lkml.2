Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab1EKWpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:45:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932265Ab1EKWo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:44:59 -0400
Date: Wed, 11 May 2011 15:44:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: rtc-linux@googlegroups.com
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [rtc-linux] [PATCH] tile: add an RTC driver for the Tilera
 hypervisor
Message-Id: <20110511154407.ed3c0480.akpm@linux-foundation.org>
In-Reply-To: <201105042004.p44K4hh5011720@farm-0032.internal.tilera.com>
References: <201105042004.p44K4hh5011720@farm-0032.internal.tilera.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011 15:52:21 -0400
Chris Metcalf <cmetcalf@tilera.com> wrote:

> This is a simple RTC driver that lets Tilera hardware boot up and
> set the clock correctly.
> 
>
> ...
>
> +static int __init tile_rtc_driver_init(void)
> +{
> +	int err;
> +
> +	err = platform_driver_register(&tile_rtc_platform_driver);
> +	if (err)
> +		return err;
> +
> +	tile_rtc_platform_device = platform_device_alloc("rtc-tile", 0);
> +	if (tile_rtc_platform_device == NULL) {
> +		platform_driver_unregister(&tile_rtc_platform_driver);
> +		return -ENOMEM;
> +	}
> +
> +	err = platform_device_add(tile_rtc_platform_device);
> +	if (err) {
> +		platform_device_put(tile_rtc_platform_device);

should we have a platform_driver_unregister() here?

> +		return err;
> +	}
> +
> +	return 0;
> +}
>
> ...
>
