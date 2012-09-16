Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab2IPBWG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 21:22:06 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:49095 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2IPBWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 21:22:02 -0400
Date: Sun, 16 Sep 2012 01:22:01 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Felipe Balbi <balbi@ti.com>, Shubhrajyoti Datta <shubhrajyoti@ti.com>
cc: Greg KH <gregkh@linuxfoundation.org>, alan@linux.intel.com,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: [PATCH v4 00/21] OMAP UART Patches
In-Reply-To: <20120912062259.GC18563@arwen.pp.htv.fi>
Message-ID: <alpine.DEB.2.00.1209160117510.23371@utopia.booyaka.com>
References: <20120906122948.GC29202@arwen.pp.htv.fi> <1346935540-1792-1-git-send-email-balbi@ti.com> <alpine.DEB.2.00.1209062137000.11516@utopia.booyaka.com> <alpine.DEB.2.00.1209112141220.9444@utopia.booyaka.com> <20120912062259.GC18563@arwen.pp.htv.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2012, Felipe Balbi wrote:

> On Tue, Sep 11, 2012 at 10:02:48PM +0000, Paul Walmsley wrote:
> 
> > The bad news is that N800 no longer boots -- or the UART dies during 
> > serial init:
> > 
> > http://www.pwsan.com/omap/testlogs/test_tty_next_e36851d0/20120910020323/boot/2420n800/2420n800_log.txt
> > 
> > The problem doesn't seem to affect the 2430SDP.
> > 
> > Could you put together a patch to fix N800?

Bisected this down.  It's this one that causes the problem on N800:

commit 93220dcc3052182e7156c09655ad1316055564b9
Author: Felipe Balbi <balbi@ti.com>
Date:   Thu Sep 6 15:45:27 2012 +0300

    serial: omap: set dev->drvdata before enabling pm_runtime
    
    by the time we call our first pm_runtme_get_sync()
    after enable pm_runtime, our resume method might
    be called. To avoid problems, we must make sure
    that our dev->drvdata is set correctly before
    our resume method gets called.
    
    Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
    Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Signed-off-by: Felipe Balbi <balbi@ti.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

- Paul
