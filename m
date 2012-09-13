Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab2IMSTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:19:35 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34753 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750828Ab2IMSTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:19:33 -0400
Message-ID: <1347560357.5884.7.camel@joe2Laptop>
Subject: Re: [PATCH 07/24] Staging: ipack/devices/ipoctal: Store isr masks
 in ipoctal_channel
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Date: Thu, 13 Sep 2012 11:19:17 -0700
In-Reply-To: <20120913174927.GA13767@mwanda>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
	 <1347454546-23236-7-git-send-email-siglesias@igalia.com>
	 <20120913174312.GB4587@mwanda> <20120913174927.GA13767@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 20:49 +0300, Dan Carpenter wrote:
> On Thu, Sep 13, 2012 at 08:43:12PM +0300, Dan Carpenter wrote:
> > On Wed, Sep 12, 2012 at 02:55:29PM +0200, Samuel Iglesias Gonsalvez wrote:
> > > From: Jens Taprogge <jens.taprogge@taprogge.org>
> > > 
> > > This way interrupt handling becomes independent of the channel number.
> > > 
> > > Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> > > Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> > > ---
> > > @@ -213,7 +206,7 @@ static int ipoctal_irq_handler(void *arg)
> > >  		}
> > >  
> > >  		/* RX data */
> > > -		if (isr_rx_rdy && (sr & SR_RX_READY)) {
> > > +		if ((isr && channel->isr_rx_rdy_mask) && (sr & SR_RX_READY)) {
> >                          ^^
> > Bitwise AND intended here I think.
> > 
> 
> Never mind.  It gets silently fixed in the next patch.

Nope, you were right the first time.

It shouldn't be silently fixed,

The best path is to rework the original patch
to fix the misuse or the worse path is that the
subsequent patch log should mention the fix.


