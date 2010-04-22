Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab0DVRDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 13:03:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647Ab0DVRDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 13:03:38 -0400
Date: Thu, 22 Apr 2010 10:02:07 -0700
From: Greg KH <gregkh@suse.de>
To: Eric Lescouet <eric.lescouet@vlx.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "usbip-devel@lists.sourceforge.net" 
	<usbip-devel@lists.sourceforge.net>
Subject: Re: [PATCH]: Fix deadlock in USBIP driver (staging),
 linux-2.6.34-rc5
Message-ID: <20100422170207.GA18830@suse.de>
References: <4BD07F2A.8080808@VirtualLogix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD07F2A.8080808@VirtualLogix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 06:54:02PM +0200, Eric Lescouet wrote:
> Hi,
> When detaching a port from the client side (usbip --detach 0),
> the event thread, on the server side, is going to deadlock.
> The "eh" server thread is getting USBIP_EH_RESET event and calls:
>  -> stub_device_reset() -> usb_reset_device()
> the USB framework is then calling back _in the same "eh" thread_ :
>  -> stub_disconnect() -> usbip_stop_eh() -> wait_for_completion()
> the "eh" thread is being asleep forever, waiting for its own completion.
> The patch checks if "eh" is the current thread, in usbip_stop_eh().

Ok, but does the lock_kernel() call you just made actually prevent this
from happening?  Isn't there some other lock you can use instead?

> Please Cc me in reply, I'm not in the list.

Also, to have patches that we can apply, we need a "Signed-off-by:"
line.  See the file, Documentation/SubmittingPatches for what this
means.
> 
> b.r.
> 
> ------------------
> 
> diff -Nur linux-2.6.34-rc5/drivers/staging/usbip/usbip_event.c
> linux-2.6.34-rc5.new/drivers/staging/usbip/usbip_event.c
> --- linux-2.6.34-rc5/drivers/staging/usbip/usbip_event.c
> 2010-04-20 01:29:56.000000000 +0200

Your email client wrapped the patch and made it unappliable :(

thanks,

greg k-h
