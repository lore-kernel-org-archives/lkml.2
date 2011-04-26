Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1DZTxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:53:55 -0400
Received: from 1wt.eu ([62.212.114.60]:35052 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab1DZTxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:53:53 -0400
Date: Tue, 26 Apr 2011 21:53:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 090/173] USB: serial/kobil_sct, fix potential tty NULL dereference
Message-ID: <20110426195342.GB19594@1wt.eu>
References: <20110425200236.905912775@pcw.home.local> <4DB6994B.3060204@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB6994B.3060204@suse.cz>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 12:07:07PM +0200, Jiri Slaby wrote:
> On 04/25/2011 10:04 PM, Willy Tarreau wrote:
> >2.6.27.59-stable review patch.  If anyone has any objections, please let 
> >us know.
> >
> >------------------
> >
> >From: Jiri Slaby<jslaby@suse.cz>
> >
> >commit 6960f40a954619857e7095a6179eef896f297077 upstream.
> >
> >Make sure that we check the return value of tty_port_tty_get.
> >Sometimes it may return NULL and we later dereference that.
> >
> >The only place here is in kobil_read_int_callback, so fix it.
> >
> >Signed-off-by: Jiri Slaby<jslaby@suse.cz>
> >Cc: Alan Cox<alan@linux.intel.com>
> >Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
> >
> >---
> >  drivers/usb/serial/kobil_sct.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >--- a/drivers/usb/serial/kobil_sct.c
> >+++ b/drivers/usb/serial/kobil_sct.c
> >@@ -372,7 +372,7 @@ static void kobil_read_int_callback(stru
> >  	}
> >
> >  	tty = port->port.tty;
> >-	if (urb->actual_length) {
> >+	if (tty&&  urb->actual_length) {
> 
> Ok, but this doesn't fix the bug (the URB should be killed or something 
> similar in that kernel), it only makes the window smaller.

OK I get it now, it requires patch 4a90f09b which is quite not some
suitable material for -longterm.

Do you think it's better to completely remove this patch than making
one think the risk of bug is gone while it is not ? Unless we find
something more reliable, I'd rather drop the patch.

Thanks,
Willy

