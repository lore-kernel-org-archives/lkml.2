Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab0KLRdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:33:54 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40018 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0KLRdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:33:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dzj9+xZpvcPArzqVzWSknHQyNaYEdZ0UuohVj5+v/23eHElDFqKpjc68t+C/Llj5/H
         Rhm11bklDyKRFzbxtYelvvkdI9TZweI+hl0rEuCYOzOA9BsE24FKcSe++59LLoMjBXqs
         gXmJpaxNRo0MKhdVphPMkmreQWNWa/KiMcyZM=
Date: Fri, 12 Nov 2010 09:33:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Marko Friedemann <mfr@bmx-chemnitz.de>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 1/3] Input: xpad - return proper error in error path
Message-ID: <20101112173343.GC1224@core.coreip.homeip.net>
References: <1289530116.20782.2.camel@mola>
 <201011121441.08298.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011121441.08298.oneukum@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 02:41:08PM +0100, Oliver Neukum wrote:
> Am Freitag, 12. November 2010, 03:48:36 schrieb Axel Lin:
> > In current implementation, xpad_probe return 0 when
> > usb_alloc_urb failed for xpad->bulk_out and kzalloc failed for xpad->bdata.
> > 
> > This patch removes the initialization for error variable,
> > assign the error code at the place the error happens instead.
> 
> I am afraid you cannot let stand the order of allocations here anyway,
> as xpad->irq_in is currently submitted before xpad->bulk_out is allocated.
> That however is a race, because the callback for irq_in can call
> xpad360w_process_packet(), which will in turn submit the bulk URB.
> 
> I am afraid your patch is pointless unless the logic is also fixed.

I do not think it is fair to call the patch pointless. It does fix the
resource leak and can be a basis for further rework.

-- 
Dmitry
