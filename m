Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2K3BXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 20:23:23 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:49303 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab2K3BXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 20:23:21 -0500
Date: Thu, 29 Nov 2012 17:23:16 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Johan Hovold <jhovold@gmail.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH 245/270] USB: mct_u232: fix broken close
Message-ID: <20121130012316.GC16996@kroah.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
 <1353949160-26803-246-git-send-email-herton.krzesinski@canonical.com>
 <1354032951.4266.61.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354032951.4266.61.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 04:15:51PM +0000, Ben Hutchings wrote:
> On Mon, 2012-11-26 at 14:58 -0200, Herton Ronaldo Krzesinski wrote:
> > 3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Johan Hovold <jhovold@gmail.com>
> > 
> > commit 5260e458f5eff269a43e4f1e9c47186c57b88ddb upstream.
> > 
> > Make sure generic close is called at close.
> > 
> > The driver relies on the generic write implementation but did not call
> > generic close.
> > 
> > Note that the call to kill the read urb is not redundant, as mct_u232
> > uses an interrupt urb from the second port as the read urb and that
> > generic close therefore fails to kill it.
> > 
> > Compile-only tested.
> > 
> > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> [...]
> 
> This is missing on 3.4; the version I used for 3.2 (attached) should be
> applicable.

Thanks, that works.

greg k-h
