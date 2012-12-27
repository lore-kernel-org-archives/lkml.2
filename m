Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab2L0NDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 08:03:38 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:49809 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752046Ab2L0NDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 08:03:36 -0500
Message-ID: <1356613404.16896.4.camel@thor.lan>
Subject: Re: [REGRESSION][3.8.-rc1][ INFO: possible circular locking
 dependency detected ]
From: Peter Hurley <peter@hurleysoftware.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 27 Dec 2012 08:03:24 -0500
In-Reply-To: <20121227083618.GA9775@S2101-09.ap.freescale.net>
References: <201212221628.26640.maciej.rutecki@gmail.com>
	 <20121226023435.GE25478@S2101-09.ap.freescale.net>
	 <20121227083618.GA9775@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-27 at 16:36 +0800, Shawn Guo wrote:
> On Wed, Dec 26, 2012 at 10:34:39AM +0800, Shawn Guo wrote:
> > It seems that I'm running into the same locking issue.  My setup is:
> > 
> > - i.MX28 (ARM)
> > - v3.8-rc1
> > - mxs_defconfig
>   - The warning is seen when LCD is blanking
> > 
> 
> The warning disappears after reverting patch daee779 (console: implement
> lockdep support for console_lock).  Is it suggesting that the mxs
> frame buffer driver (drivers/video/mxsfb.c) is doing something bad?
> 
> Shawn
> 
> > 
> > [  602.229899] ======================================================
> > [  602.229905] [ INFO: possible circular locking dependency detected ]
> > [  602.229926] 3.8.0-rc1-00003-gde4ae7f #767 Not tainted
> > [  602.229933] -------------------------------------------------------
> > [  602.229951] kworker/0:1/21 is trying to acquire lock:
> > [  602.230037]  ((fb_notifier_list).rwsem){.+.+.+}, at: [<c0041f34>] __blocking_notifier_call_chain+0x2c/0x60

You want this patch https://patchwork.kernel.org/patch/1757061/


