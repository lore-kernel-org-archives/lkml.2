Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab2JATvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:51:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39154 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493Ab2JATvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:51:09 -0400
X-Sasl-enc: qxCtDNzCY8QZEur1BA/jVnEhIyyomsXjIoyuCatqB0dm 1349121068
Date: Mon, 1 Oct 2012 12:51:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Igor Grinberg <grinberg@compulab.co.il>,
        Paul Walmsley <paul@pwsan.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [ 045/218] ARM: OMAP: timer: obey the !CONFIG_OMAP_32K_TIMER
Message-ID: <20121001195107.GA14278@kroah.com>
References: <20120928201501.208384923@linuxfoundation.org>
 <20120928201506.626237283@linuxfoundation.org>
 <20121001182046.GB3198@herton-Z68MA-D2H-B3>
 <20121001183343.GA13126@kroah.com>
 <20121001185303.GC3198@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001185303.GC3198@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 03:53:04PM -0300, Herton Ronaldo Krzesinski wrote:
> On Mon, Oct 01, 2012 at 11:33:43AM -0700, Greg Kroah-Hartman wrote:
> > On Mon, Oct 01, 2012 at 03:20:46PM -0300, Herton Ronaldo Krzesinski wrote:
> > > On Fri, Sep 28, 2012 at 01:14:22PM -0700, Greg Kroah-Hartman wrote:
> > > > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Igor Grinberg <grinberg@compulab.co.il>
> > > > 
> > > > commit 45caae74d238ef6583e9402cb8c550cc0b0f7dbd upstream.
> > > > 
> > > > Currently, omap2_sync32k_clocksource_init() function initializes the 32K
> > > > timer as the system clock source regardless of the CONFIG_OMAP_32K_TIMER
> > > > setting.
> > > > Fix this by providing a default implementation for
> > > > !CONFIG_OMAP_32K_TIMER case.
> > > > 
> > > > Signed-off-by: Igor Grinberg <grinberg@compulab.co.il>
> > > > Reviewed-by: Paul Walmsley <paul@pwsan.com>
> > > > Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > > > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > 
> > > > ---
> > > >  arch/arm/mach-omap2/timer.c |    7 +++++++
> > > >  1 file changed, 7 insertions(+)
> > > 
> > > Build failure with this patch:
> > > 
> > > linux/arch/arm/mach-omap2/timer.c:308:2: error: #else after #else
> > > linux/arch/arm/mach-omap2/timer.c:238:0: error: the conditional began here
> > > linux/arch/arm/mach-omap2/timer.c:326:21: error: expected declaration specifiers or '...' before numeric constant
> > > linux/arch/arm/mach-omap2/timer.c:326:24: error: expected declaration specifiers or '...' before numeric constant
> > > linux/arch/arm/mach-omap2/timer.c:326:27: error: expected declaration specifiers or '...' before string constant
> > > linux/arch/arm/mach-omap2/timer.c:326:47: error: expected declaration specifiers or '...' before numeric constant
> > > linux/arch/arm/mach-omap2/timer.c:326:50: error: expected declaration specifiers or '...' before string constant
> > > linux/arch/arm/mach-omap2/timer.c:328:21: error: invalid suffix "_secure" on integer constant
> > > linux/arch/arm/mach-omap2/timer.c:328:21: error: expected declaration specifiers or '...' before numeric constant
> > > linux/arch/arm/mach-omap2/timer.c:328:31: error: expected declaration specifiers or '...' before numeric constant
> > > linux/arch/arm/mach-omap2/timer.c:328:51: error: expected declaration specifiers or '...' before string constant
> > > linux/arch/arm/mach-omap2/timer.c:329:4: error: expected declaration specifiers or '...' before numeric constant
> > > linux/arch/arm/mach-omap2/timer.c:329:7: error: expected declaration specifiers or '...' before string constant
> > 
> > Does it also fail in Linus's tree?  Was there a follow-on patch that
> > fixed the build issues?
> 
> I only saw the build failure, and proposed 3.5.5 which have the same patch
> builds fine. It looks like this patch isn't applicable to 3.4 (that seems to be
> fixing a problem in commit 1fe97c8f).

Ah, nice catch, I'll go drop this patch from the 3.4-stable queue,
thanks for letting me know.

greg k-h
