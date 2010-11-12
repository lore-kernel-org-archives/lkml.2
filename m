Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab0KLNkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:40:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:54789 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab0KLNkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:40:40 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH 1/3] Input: xpad - return proper error in error path
Date: Fri, 12 Nov 2010 14:41:08 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Marko Friedemann <mfr@bmx-chemnitz.de>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        linux-input@vger.kernel.org
References: <1289530116.20782.2.camel@mola>
In-Reply-To: <1289530116.20782.2.camel@mola>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011121441.08298.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 12. November 2010, 03:48:36 schrieb Axel Lin:
> In current implementation, xpad_probe return 0 when
> usb_alloc_urb failed for xpad->bulk_out and kzalloc failed for xpad->bdata.
> 
> This patch removes the initialization for error variable,
> assign the error code at the place the error happens instead.

I am afraid you cannot let stand the order of allocations here anyway,
as xpad->irq_in is currently submitted before xpad->bulk_out is allocated.
That however is a race, because the callback for irq_in can call
xpad360w_process_packet(), which will in turn submit the bulk URB.

I am afraid your patch is pointless unless the logic is also fixed.

	Regards
		Oliver
