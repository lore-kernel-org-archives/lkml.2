Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2IMSoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:44:16 -0400
Received: from shamrock.taprogge.org ([213.146.117.139]:60439 "EHLO
	shamrock.taprogge.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2IMSoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:44:14 -0400
Date: Thu, 13 Sep 2012 20:43:46 +0200
From: Jens Taprogge <jens.taprogge@taprogge.org>
To: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 07/24] Staging: ipack/devices/ipoctal: Store isr masks in
 ipoctal_channel
Message-ID: <20120913184346.GA11613@endeavour.taprogge.org>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
 <1347454546-23236-7-git-send-email-siglesias@igalia.com>
 <20120913174312.GB4587@mwanda>
 <20120913174927.GA13767@mwanda>
 <1347560357.5884.7.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347560357.5884.7.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Anti-Spam: Skipped scanning; message comes from a trusted host.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 11:19:17AM -0700, Joe Perches wrote:
> On Thu, 2012-09-13 at 20:49 +0300, Dan Carpenter wrote:
> > On Thu, Sep 13, 2012 at 08:43:12PM +0300, Dan Carpenter wrote:
> > > On Wed, Sep 12, 2012 at 02:55:29PM +0200, Samuel Iglesias Gonsalvez wrote:
> > > > From: Jens Taprogge <jens.taprogge@taprogge.org>
> > > > 
> > > > This way interrupt handling becomes independent of the channel number.
> > > > 
> > > > Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> > > > Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> > > > ---
> > > > @@ -213,7 +206,7 @@ static int ipoctal_irq_handler(void *arg)
> > > >  		}
> > > >  
> > > >  		/* RX data */
> > > > -		if (isr_rx_rdy && (sr & SR_RX_READY)) {
> > > > +		if ((isr && channel->isr_rx_rdy_mask) && (sr & SR_RX_READY)) {
> > >                          ^^
> > > Bitwise AND intended here I think.
> > > 
> > 
> > Never mind.  It gets silently fixed in the next patch.
> 
> Nope, you were right the first time.
> 
> It shouldn't be silently fixed,
> 
> The best path is to rework the original patch
> to fix the misuse or the worse path is that the
> subsequent patch log should mention the fix.

I am sorry this slipped through.  The patches are already in
staging-next.  What is the best action to take now?  Should I prepare
the two patches with the issue fixed?

Best Regards,
Jens
