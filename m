Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab1AGPH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:07:28 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36295 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751129Ab1AGPH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:07:27 -0500
Date: Fri, 7 Jan 2011 16:07:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [000/152] 2.6.36.3-stable review
Message-ID: <20110107150724.GA29082@atrey.karlin.mff.cuni.cz>
References: <20110106002500.GA3172@kroah.com> <20110106134254.68fa27ac@lxorguk.ukuu.org.uk> <20110106215705.GA30799@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106215705.GA30799@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jan 06, 2011 at 01:42:54PM +0000, Alan Cox wrote:
> > On Wed, 5 Jan 2011 16:25:00 -0800
> > Greg KH <gregkh@suse.de> wrote:
> > 
> > > 
> > > This is the start of the stable review cycle for the 2.6.36.3 release.
> > > There are 152 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let us know.  If anyone is a maintainer of the proper subsystem, and
> > > wants to add a Signed-off-by: line to the patch, please respond with it.
> > 
> > Look sane on first glance but we don't seem to have a revert for the
> > serial mess up yet ?
> > 
> > > 7a56aa45982bb87bfca98a2832b5ae782c03364a is the first bad commit 
> > > commit 7a56aa45982bb87bfca98a2832b5ae782c03364a
> > > Author: Yegor Yefremov <yegor_sub1@visionsystems.de>
> > > Date:   Wed Jun 16 16:29:55 2010 +0200
> > > 
> > >     serial: add UART_CAP_EFR and UART_CAP_SLEEP flags to 16C950 UARTs 
> > > definition
> > >     
> > >     Adding UART_CAP_EFR and UART_CAP_SLEEP flags will enable sleep 
> > > mode
> > >     and automatic CTS flow control for 16C950 UARTs. It will also 
> > > avoid
> > >     capabilities detection warning like this:
> > >     
> > >     "ttyS0: detected caps 00000700 should be 00000100"
> > >     
> > >     Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
> > >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > 
> > Has been bisected by several people to be causing failures and reported ?
> 
> Hm, I saw Pavel reported a problem, but I didn't get a definate "this
> must be reverted" resolution from that thread.  It looked like we should
> just drop one of these flags perhaps?
> 
> I can revert it if it really is an issue, but it needs to be reverted in
> Linus's tree first, before going to stable.

Flow control flag seems to be responsible.

But... it hits me and then... me. So I'd like to see it resolved in
devel tree, but it may not 100% vital for stable.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
