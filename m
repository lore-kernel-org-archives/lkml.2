Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179Ab0JTNJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:09:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38969 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab0JTNJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:09:06 -0400
Date: Wed, 20 Oct 2010 15:09:03 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        daniel@caiaq.de, xiao-lizhang@freescale.com,
        valentin.longchamp@epfl.ch
Subject: Re: [PATCH] ARM: imx: change mx51.h into mx5x.h
Message-ID: <20101020130903.GA19834@pengutronix.de>
References: <1287525423-22329-1-git-send-email-Dinh.Nguyen@freescale.com> <20101020090122.GH28166@pengutronix.de> <20101020113550.GL2562@matterhorn.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101020113550.GL2562@matterhorn.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Amit,

On Wed, Oct 20, 2010 at 02:35:50PM +0300, Amit Kucheria wrote:
> On 10 Oct 20, Uwe Kleine-König wrote:
> > Hello Dinh,
> > 
> > On Tue, Oct 19, 2010 at 04:57:03PM -0500, Dinh.Nguyen@freescale.com wrote:
> > > From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> > > 
> > > In preparation for submitting i.MX53 support, change mx51.h to
> > > mx5x.h so that mx5x.h can contain MX53 information as well.
> > Last time I found time to clean up the imx ports I worked hard that e.g.
> > mx27 machines only used MX27_ prefixed symbols, not the MX2x_ ones.  (I
> > don't remember off-hand if I was done, so there might be a few users
> > left.)
> > 
> > I'd prefer to just add an mx53.h instead.
> 
> Perhaps this is a good time to ask the question - Why?
> 
> mx53.h will duplicate (almost) everything in mx51.h. And any fixes made to
> mx51.h won't make it to mx53.h
Yep, that's the pro side of having a single header file for both mx51
and mx53.  On the negative side we have:

 - When changing mx5x.h you always have to check (now) two reference
   manuals, later maybe more.
 - When Freescale decides to create a (say) mx56 that is totally
   different, you can be happy not to have constants starting with MX5X.
   (This happened to the MX2X constants when Freescale created mx25, not
   to mention mx23 and mx28.)

I admit that *now* it would be easier to just rename mx51.h to mx5x.h,
but for the long run keeping mx51.h is better, I'm sure.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
