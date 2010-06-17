Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598Ab0FQRxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:53:36 -0400
Received: from kroah.org ([198.145.64.141]:48800 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760420Ab0FQRwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:52:43 -0400
Date: Thu, 17 Jun 2010 10:44:06 -0700
From: Greg KH <greg@kroah.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/6] USB-BKL: Remove BKL use in uhci-debug
Message-ID: <20100617174406.GB3644@kroah.com>
References: <1275426285-9088-1-git-send-email-arnd@arndb.de>
 <1275426285-9088-5-git-send-email-arnd@arndb.de>
 <4C062E69.8050406@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C062E69.8050406@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 02:11:53PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> Arnd Bergmann wrote:
> 
> >From: Andi Kleen <ak@linux.intel.com>
> 
> >BKL was not really needed, just came from earlier push downs.
> 
> >The only part that's a bit dodgy is the lseek function. Would
> >need another lock or atomic access to fpos on 32bit?
> >Better to have a libfs lseek
> 
> >Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> [...]
> 
> >diff --git a/drivers/usb/host/uhci-debug.c b/drivers/usb/host/uhci-debug.c
> >index 98cf0b2..b0cf4f8 100644
> >--- a/drivers/usb/host/uhci-debug.c
> >+++ b/drivers/usb/host/uhci-debug.c
> 
> [...]
> 
> >@@ -539,11 +534,11 @@ static loff_t uhci_debug_lseek(struct file *file, loff_t off, int whence)
> > 		new = file->f_pos + off;
> > 		break;
> > 	}
> >+
> >+	/* XXX: Can size shrink? */
> > 	if (new < 0 || new > up->size) {
> >-		unlock_kernel();
> > 		return -EINVAL;
> > 	}
> 
>    Should have dropped {}...

I've fixed that up in the version that got applied.

thanks,

greg k-h
