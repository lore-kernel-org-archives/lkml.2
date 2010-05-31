Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab0EaHzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:55:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222Ab0EaHzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:55:03 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH v2] cdc-acm: fix resource reclaim in error path of acm_probe
Date: Mon, 31 May 2010 09:55:17 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.name>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       Francesco Lavra <francescolavra@interfree.it>,
       Julian Calaby <julian.calaby@gmail.com>, linux-usb@vger.kernel.org
References: <1275264287.20355.2.camel@mola>
In-Reply-To: <1275264287.20355.2.camel@mola>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005310955.17278.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 31. Mai 2010 02:04:47 schrieb Axel Lin:
> This patch fixes resource reclaim in error path of acm_probe:
> 1. In the case of "out of memory (read urbs usb_alloc_urb)\n")",
> there is no need to call acm_read_buffers_free(acm) here.
> Fix it by goto alloc_fail6 instead of alloc_fail7.
> 2. In the case of "out of memory (write urbs usb_alloc_urb)",
> usb_alloc_urb may fail in any iteration of the for loop.
> Current implementation does not properly free allocated snd->urb.
> Fix it by goto alloc_fail8 instead of alloc_fail7.
> 3. In the case of device_create_file(&intf->dev,&dev_attr_iCountryCodeRelDate)
> fail, acm->country_codes is kfreed. As a result, device_remove_file for
> dev_attr_wCountryCodes will not be executed in acm_disconnect.
> Fix it by calling device_remove_file for dev_attr_wCountryCodes before goto
> skip_countries.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.de>
