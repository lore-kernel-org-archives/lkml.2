Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab2B2SxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:53:09 -0500
Received: from matrixpower.ru ([195.178.208.66]:53509 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755239Ab2B2SxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:53:07 -0500
Date: Wed, 29 Feb 2012 21:52:59 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Renata Sayakhova <rsayakhova@gmail.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] DS2781 Maxim Stand-Alone Fuel Gauge battery and w1
 slave drivers
Message-ID: <20120229185259.GC32077@ioremap.net>
References: <1330523933-32344-1-git-send-email-rsayakhova@gmail.com>
 <1330523933-32344-2-git-send-email-rsayakhova@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330523933-32344-2-git-send-email-rsayakhova@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Renata

On Wed, Feb 29, 2012 at 02:58:53PM +0100, Renata Sayakhova (rsayakhova@gmail.com) wrote:
> 
> Signed-off-by: Renata Sayakhova <rsayakhova@gmail.com>

Patch looks good except this weird function

> +static inline int ds2781_battery_io(struct ds2781_device_info *dev_info,
> +	char *buf, int addr, size_t count, int io)
> +{
> +	if (dev_info->mutex_holder == current)
> +		return w1_ds2781_io_nolock(dev_info->w1_dev, buf, addr,
> +				count, io);
> +	else
> +		return w1_ds2781_io(dev_info->w1_dev, buf, addr, count, io);
> +}

Who in the stack can run away holding mutex?

-- 
	Evgeniy Polyakov
