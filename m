Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab0DVTTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:19:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:57128 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab0DVTTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:19:13 -0400
Date: Thu, 22 Apr 2010 11:51:36 -0700
From: Greg KH <gregkh@suse.de>
To: Eric Lescouet <Eric.Lescouet@VirtualLogix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "usbip-devel@lists.sourceforge.net" 
	<usbip-devel@lists.sourceforge.net>
Subject: Re: [PATCH]: Fix deadlock in USBIP driver (staging),
 linux-2.6.34-rc5
Message-ID: <20100422185136.GA2937@suse.de>
References: <4BD07F2A.8080808@VirtualLogix.com>
 <20100422170207.GA18830@suse.de>
 <4BD09175.9030703@VirtualLogix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD09175.9030703@VirtualLogix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 08:12:05PM +0200, Eric Lescouet wrote:
> Greg KH wrote:
> [...]
> >Ok, but does the lock_kernel() call you just made actually prevent this
> >from happening?  Isn't there some other lock you can use instead?
> >
> 
> Right. lock_kernel() is not needed (was copy/paste).
> The deadlock is avoided by not calling wait_for_completion()
> when the code is executed by the "eh" thread itself.
> 
> >Also, to have patches that we can apply, we need a "Signed-off-by:"
> >line.  See the file, Documentation/SubmittingPatches for what this
> >means.
> 
> Understood.
> 
> >Your email client wrapped the patch and made it unappliable :(
> >
> >thanks,
> >
> >greg k-h
> 
> Sorry about that. Please find below an hopefully better one.
> Thanks,
> 	Eric.
> 
> 
> Signed-off-by: Eric Lescouet <eric@lescouet.org>
> -------------
> 
> diff -Nur linux-2.6.34-rc5/drivers/staging/usbip/usbip_event.c
> linux-2.6.34-rc5.new/drivers/staging/usbip/usbip_event.c
> --- linux-2.6.34-rc5/drivers/staging/usbip/usbip_event.c
> 2010-04-20 01:29:56.000000000 +0200
> +++ linux-2.6.34-rc5.new/drivers/staging/usbip/usbip_event.c
> 2010-04-22 19:19:52.997889126 +0200
> @@ -117,6 +117,9 @@
> {
> struct usbip_task *eh = &ud->eh;
> +       if (eh->thread == current)
> +               return; /* do not wait for myself */
> +
> wait_for_completion(&eh->thread_done);
> usbip_dbg_eh("usbip_eh has finished\n");

Odd, the patch has all leading tabs and spaces stripped out of it, is
linewrapped, and the tabs are converted to spaces :(

Care to try again, third time's a charm...

thanks,

greg k-h
