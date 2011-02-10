Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1BJNTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 08:19:25 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:59420 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754058Ab1BJNTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 08:19:23 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 10 Feb 2011 14:18:16 +0100
To: Alexander Strakh <cromlehg@gmail.com>
Cc: dmitry.torokhov@gmail.com, oneukum@suse.de, oblivian@users.sourceforge.net,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Strakh <strakh@ispras.ru>
Subject: Re: [PATCH 1/1] Fix error path in wacom_probe
Message-ID: <20110210131816.GB8935@polaris.bitmath.org>
References: <1297237048-32714-1-git-send-email-strakh@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297237048-32714-1-git-send-email-strakh@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.192.164
X-Scan-Result: No virus found in message 1PnWPN-00018w-4K.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PnWPN-00018w-4K 09bb22401963de16c3c6510c72ba327f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

>   In file drivers/input/tablet/wacom_sys.c in
> wacom_probe after error we can goto label2. In
>  this case function usb_free was not called. 
>  It will be right goto for the label tail3.
> 
>         wacom->irq = usb_alloc_urb(0, GFP_KERNEL);
> 
> 	...
> 
>         /* Retrieve the physical and logical size for OEM devices */
>         error = wacom_retrieve_hid_descriptor(intf, features);
>         if (error)
>                 goto fail2;
> 	...
> 	 fail3: usb_free_urb(wacom->irq);
> 	 fail2: usb_free_coherent(dev, WACOM_PKGLEN_MAX, wacom_wac->data, wacom->data_dma);
> 
> Replaced wrong transition.

Yep, thanks for this.

Acked-by: Henrik Rydberg <rydberg@euromail.se>
