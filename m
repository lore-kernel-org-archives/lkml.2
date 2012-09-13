Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab2IMTSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 15:18:30 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:41432 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2IMTS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 15:18:28 -0400
Date: Thu, 13 Sep 2012 22:17:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>
Cc: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 07/24] Staging: ipack/devices/ipoctal: Store isr masks in
 ipoctal_channel
Message-ID: <20120913191717.GB13767@mwanda>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
 <1347454546-23236-7-git-send-email-siglesias@igalia.com>
 <20120913174312.GB4587@mwanda>
 <20120913174927.GA13767@mwanda>
 <1347560357.5884.7.camel@joe2Laptop>
 <20120913184346.GA11613@endeavour.taprogge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913184346.GA11613@endeavour.taprogge.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 08:43:46PM +0200, Jens Taprogge wrote:
> On Thu, Sep 13, 2012 at 11:19:17AM -0700, Joe Perches wrote:
> > On Thu, 2012-09-13 at 20:49 +0300, Dan Carpenter wrote:
> > > On Thu, Sep 13, 2012 at 08:43:12PM +0300, Dan Carpenter wrote:
> > > > On Wed, Sep 12, 2012 at 02:55:29PM +0200, Samuel Iglesias Gonsalvez wrote:
> > > > > From: Jens Taprogge <jens.taprogge@taprogge.org>
> > > > > 
> > > > > This way interrupt handling becomes independent of the channel number.
> > > > > 
> > > > > Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> > > > > Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> > > > > ---
> > > > > @@ -213,7 +206,7 @@ static int ipoctal_irq_handler(void *arg)
> > > > >  		}
> > > > >  
> > > > >  		/* RX data */
> > > > > -		if (isr_rx_rdy && (sr & SR_RX_READY)) {
> > > > > +		if ((isr && channel->isr_rx_rdy_mask) && (sr & SR_RX_READY)) {
> > > >                          ^^
> > > > Bitwise AND intended here I think.
> > > > 
> > > 
> > > Never mind.  It gets silently fixed in the next patch.
> > 
> > Nope, you were right the first time.
> > 
> > It shouldn't be silently fixed,
> > 
> > The best path is to rework the original patch
> > to fix the misuse or the worse path is that the
> > subsequent patch log should mention the fix.
> 
> I am sorry this slipped through.  The patches are already in
> staging-next.  What is the best action to take now?  Should I prepare
> the two patches with the issue fixed?

If it weren't in staging-next then, yeah, it probably would have
been better to resend those two patches.  You could send them by
themselves without resending any of the others.  But once they hit
staging-next, it's too late.

No stress.

regards,
dan carpenter

