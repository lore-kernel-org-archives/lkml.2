Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab0E1FqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 01:46:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:51846 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab0E1FqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 01:46:11 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] cdc-acm: fix resource reclaim in error path of acm_probe
Date: Fri, 28 May 2010 07:45:06 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.name>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       Francesco Lavra <francescolavra@interfree.it>,
       Julian Calaby <julian.calaby@gmail.com>, linux-usb@vger.kernel.org
References: <1275017311.11371.2.camel@mola>
In-Reply-To: <1275017311.11371.2.camel@mola>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201005280745.06299.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 28. Mai 2010 05:28:31 schrieb Axel Lin:
> This patch fixes resource reclaim in error path of acm_probe:
> 1. In the case of "out of memory (write urbs usb_alloc_urb)",
> usb_alloc_urb may fail in any iteration of the for loop.
> Current implementation does not properly free allocated snd->urb.

Yes.

> 2. In the case of device_create_file(&intf->dev,&dev_attr_iCountryCodeRelDate)
> fail, acm->country_codes is kfreed. As a result, device_remove_file for
> dev_attr_wCountryCodes will not be executed in acm_disconnect.

Yes.

> 3. This patch also improves the error handling by only reclaim successfully
> allocated resources instead of iterate over all entries in the for loop.

Please don't do that. Simplicity and correctness are the only goals designing
error handling.

	Regards
		Oliver
