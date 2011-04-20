Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab1DTFxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 01:53:07 -0400
Received: from 1wt.eu ([62.212.114.60]:33010 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab1DTFxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 01:53:06 -0400
Date: Wed, 20 Apr 2011 07:39:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Dmitry Torokhov <dtor@vmware.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [24/28] USB: xhci - fix unsafe macro definitions
Message-ID: <20110420053925.GC16291@1wt.eu>
References: <20110419204119.285492847@clark.kroah.org> <1303264924.3464.69.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303264924.3464.69.camel@localhost>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 03:02:04AM +0100, Ben Hutchings wrote:
> On Tue, 2011-04-19 at 13:31 -0700, Greg KH wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Dmitry Torokhov <dtor@vmware.com>
> > 
> > commit 5a6c2f3ff039154872ce597952f8b8900ea0d732 upstream.
> > 
> > Macro arguments used in expressions need to be enclosed in parenthesis
> > to avoid unpleasant surprises.
> 
> Do you know of any specific uses of these macros where the missing
> parentheses caused 'unpleasant surprises'?

In my opinion, this type of fix should be backported even if the current
code does not appear to be at risk, otherwise a later fix in the kernel
could cause a serious regression when backported to -stable. For instance,
if we later have to backport this patch (cut'n'pasted) :

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1033,7 +1033,7 @@ static inline unsigned int xhci_get_endpoint_interval(struct usb_device *udev,
        default:
                BUG();
        }
-       return EP_INTERVAL(interval);
+       return EP_INTERVAL(interval + 1);
 }

How can you guess that while works in mainline, it breaks -stable ?

As a user, I'd rather have known valid code in -stable and -longterm at the
risk of an occasional *temporary* regression than longterm unexplainable
regressions due to diverging code causing unexpected issues with backported
fixes.

Regards,
Willy

