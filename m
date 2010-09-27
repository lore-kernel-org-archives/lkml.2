Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106Ab0I0TcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:32:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:41201 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758481Ab0I0TcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:32:09 -0400
Date: Mon, 27 Sep 2010 12:28:20 -0700
From: Greg KH <gregkh@suse.de>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: security@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Staging: vt6655/vt6656 security issues
Message-ID: <20100927192820.GC25713@suse.de>
References: <1285612256.10963.44.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285612256.10963.44.camel@dan>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 02:30:56PM -0400, Dan Rosenberg wrote:
> Based on a brief glance looking for security issues, I just wanted to
> mention that these drivers are nowhere near ready to be added to the
> main kernel.  I'm not interested in developing these drivers further,
> but there are at least six stack buffer overflows:
> 
> vt6655/wpactl.c: wpa_set_keys(), line 239
> vt6655/wpactl.c: wpa_set_keys(), line 280
> vt6655/wpactl.c: wpa_set_associate(), line 770 (reported by Dan
> Carpenter)
> 
> vt6656/wpactl.c: wpa_set_keys(), line 239
> vt6656/wpactl.c: wpa_set_keys(), line 279
> vt6656/wpactl.c: wpa_set_associate(), line 779
> 
> And four heap corruption issues due to integer overflow in the
> allocation size:
> 
> vt6655/ioctl.c: private_ioctl(), line 329
> vt6655/ioctl.c: private_ioctl(), line 625
> 
> vt6656/ioctl.c: private_ioctl(), line 326
> vt6656/ioctl.c: private_ioctl(), line 615
> 
> They are all caused by unchecked copy_from_user() calls with
> user-provided length fields or kmalloc() calls with arithmetic on
> user-provided sizes.  This kind of sloppiness suggests there are almost
> certainly other major security issues in this code.

I would not doubt that at all.  For the moment, these drivers are being
used to allow users to use their machines, and a "real" driver is soon
replacing them for the long-term.  They also all run on laptops, where
such security issues are not as relevant due to the "physical access"
mode.  Not that this excuses such horrible behavior, but it does lesten
the threat model a lot.

I thank you for your patches and looking into this code, but if you
want, don't really worry about future work in this area, as the drivers
will just be deleted entirely soon (with any luck).

thanks,

greg k-h
