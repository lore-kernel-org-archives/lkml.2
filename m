Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab1IIIcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:32:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60619 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab1IIIcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:32:15 -0400
Date: Fri, 9 Sep 2011 01:31:34 -0700
From: Greg KH <gregkh@suse.de>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        akpm@linux-foundation.org, jic23@cam.ac.kr, kyungmin.park@samsung.com
Subject: Re: [PATCH v2] misc: Add driver for GP2AP002 proximity/ambient light
 sensor
Message-ID: <20110909083134.GA21835@suse.de>
References: <1315556546-7445-1-git-send-email-dg77.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315556546-7445-1-git-send-email-dg77.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 05:22:26PM +0900, Donggeun Kim wrote:
> SHARP GP2AP002 is proximity and ambient light sensor.
> This patch supports it.
> 
> Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Changes for v2
>   - changed to expose lux
>   - changed request_irq to request_threaded_irq function
>   - added sysfs_notify function call

Why?  You should never do that unless you _really_ know what you are
doing.


>   - cleaned up code
> 
>  Documentation/misc-devices/gp2ap002    |   44 +++
>  drivers/misc/Kconfig                   |   10 +
>  drivers/misc/Makefile                  |    1 +
>  drivers/misc/gp2ap002.c                |  488 ++++++++++++++++++++++++++++++++
>  include/linux/platform_data/gp2ap002.h |   69 +++++


Shouldn't this be an iio driver instead of some random misc driver with
an undocumented sysfs file (hint, use Documentation/ABI for documenting
stuff...) ?


greg k-h
