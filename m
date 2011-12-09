Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab1LIQnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 11:43:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab1LIQnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 11:43:21 -0500
Date: Fri, 9 Dec 2011 08:35:08 -0800
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH] net/hyperv: Fix the stop/wake queue mechanism
Message-ID: <20111209163508.GA19001@suse.de>
References: <1322855785-22776-1-git-send-email-haiyangz@microsoft.com>
 <A1F3067C9B68744AA19F6802BAB8FFDC0CCD457B@TK5EX14MBXC227.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A1F3067C9B68744AA19F6802BAB8FFDC0CCD457B@TK5EX14MBXC227.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 04:00:59PM +0000, Haiyang Zhang wrote:
> > -----Original Message-----
> > From: Haiyang Zhang [mailto:haiyangz@microsoft.com]
> > Sent: Friday, December 02, 2011 2:56 PM
> > To: Haiyang Zhang; KY Srinivasan; davem@davemloft.net; gregkh@suse.de;
> > linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> > devel@linuxdriverproject.org
> > Subject: [PATCH] net/hyperv: Fix the stop/wake queue mechanism
> > 
> > The ring buffer is only used to pass meta data for outbound packets. The
> > actual payload is accessed by DMA from the host. So the stop/wake queue
> > mechanism based on counting and comparing number of pages sent v.s.
> > number
> > of pages in the ring buffer is wrong. Also, there is a race condition in
> > the stop/wake queue calls, which can stop xmit queue forever.
> > 
> > The new stop/wake queue mechanism is based on the actual bytes used by
> > outbound packets in the ring buffer. The check for number of outstanding
> > sends after stop queue prevents the race condition that can cause wake
> > queue happening earlier than stop queue.
> > 
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Reported-by: Long Li <longli@microsoft.com>
> > ---
> >  drivers/net/hyperv/netvsc.c     |   14 +++++++++++---
> >  drivers/net/hyperv/netvsc_drv.c |   24 +-----------------------
> >  2 files changed, 12 insertions(+), 26 deletions(-)
> 
> Hi Greg,
> 
> Since the netvsc haven't been merged into Dave's tree yet after out of staging,
> could you consider this patch for your tree?

It's in my "to-apply" queue already.

thanks,

greg k-h
