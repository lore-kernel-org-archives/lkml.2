Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2L1LpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 06:45:11 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:48053
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604Ab2L1LpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 06:45:08 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI936eI1432I1447Izz1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 28 Dec 2012 19:45:26 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Peter Hurley <peter@hurleysoftware.com>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [REGRESSION][3.8.-rc1][ INFO: possible circular locking
 dependency detected ]
Message-ID: <20121228114525.GD19447@S2101-09.ap.freescale.net>
References: <201212221628.26640.maciej.rutecki@gmail.com>
 <20121226023435.GE25478@S2101-09.ap.freescale.net>
 <20121227083618.GA9775@S2101-09.ap.freescale.net>
 <1356613404.16896.4.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1356613404.16896.4.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 08:03:24AM -0500, Peter Hurley wrote:
> On Thu, 2012-12-27 at 16:36 +0800, Shawn Guo wrote:
> > On Wed, Dec 26, 2012 at 10:34:39AM +0800, Shawn Guo wrote:
> > > It seems that I'm running into the same locking issue.  My setup is:
> > > 
> > > - i.MX28 (ARM)
> > > - v3.8-rc1
> > > - mxs_defconfig
> >   - The warning is seen when LCD is blanking
> > > 
> > 
> > The warning disappears after reverting patch daee779 (console: implement
> > lockdep support for console_lock).  Is it suggesting that the mxs
> > frame buffer driver (drivers/video/mxsfb.c) is doing something bad?
> > 
> > Shawn
> > 
> > > 
> > > [  602.229899] ======================================================
> > > [  602.229905] [ INFO: possible circular locking dependency detected ]
> > > [  602.229926] 3.8.0-rc1-00003-gde4ae7f #767 Not tainted
> > > [  602.229933] -------------------------------------------------------
> > > [  602.229951] kworker/0:1/21 is trying to acquire lock:
> > > [  602.230037]  ((fb_notifier_list).rwsem){.+.+.+}, at: [<c0041f34>] __blocking_notifier_call_chain+0x2c/0x60
> 
> You want this patch https://patchwork.kernel.org/patch/1757061/
> 
Thanks for the pointer, Peter.  It does fix the problem for me.

Shawn

