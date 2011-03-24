Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab1CXN5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:57:04 -0400
Received: from gate.eia.be ([194.78.71.18]:27250 "EHLO mail.eia.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661Ab1CXN5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:57:00 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Mar 2011 09:57:00 EDT
Date: Thu, 24 Mar 2011 14:41:42 +0100
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stalin Srinivasan <stalin.s@mistralsolutions.com>, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/7] mfd: add pruss mfd driver.
Message-ID: <20110324134142.GB27124@e-circ.dyndns.org>
Mail-Followup-To: Marc Kleine-Budde <mkl@pengutronix.de>,
	Subhasish Ghosh <subhasish@mistralsolutions.com>,
	sachi@mistralsolutions.com,
	davinci-linux-open-source@linux.davincidsp.com,
	Samuel Ortiz <sameo@linux.intel.com>,
	Stalin Srinivasan <stalin.s@mistralsolutions.com>, nsekhar@ti.com,
	open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
	linux-arm-kernel@lists.infradead.org
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com>
 <1299592667-21367-2-git-send-email-subhasish@mistralsolutions.com>
 <4D776B05.4010506@pengutronix.de>
 <384BC720F8C741B886DC000F067EBA20@subhasishg>
 <4D8B4623.4010709@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4D8B4623.4010709@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 24 Mar 2011 13:41:46.0519 (UTC) FILETIME=[380DFA70:01CBEA29]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 02:24:51PM +0100, Marc Kleine-Budde wrote:
> On 03/24/2011 02:16 PM, Subhasish Ghosh wrote:
> > Hello,
> > 
> > With make C=1 I am receiving some warnings such as:
> > 
> > warning: cast removes address space of expression
> > drivers/mfd/da8xx_pru.c:61:17: warning: incorrect type in argument 1
> > (different base types)
> > drivers/mfd/da8xx_pru.c:61:17:    expected void const volatile [noderef]
> > <asn:2>*<noident>
> > drivers/mfd/da8xx_pru.c:61:17:    got int
> > drivers/mfd/da8xx_pru.c:66:28: warning: incorrect type in argument 1
> > (different address spaces)
> 
> (Re)read the warning carefully:
> 
> You have to fix drivers/mfd/da8xx_pru.c, the first argument should be
> __void iomem *, not an int. Fix the type of the first argument. Don't
> use any casts at all, follow all warnings, eventually you will have void
> __iomem * (or struct * instead of void *) and no warnings.
> 
> > I can remove all of these by casting to (__force void  __iomem *) but is
> > this correct.
> 
> No evil casts, please :)
In addition, I learned that if a driver is not bound to a specific architecture,
you better use ioread/iowrite & friends, rather that accessing the iomemory
directly.
> 
Kurt

