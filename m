Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab2JDNMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:12:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47668 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab2JDNMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:12:50 -0400
Date: Thu, 4 Oct 2012 15:12:42 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] serial: i.MX: evaluate linux,stdout-path property
Message-ID: <20121004131242.GI1322@pengutronix.de>
References: <1349347191-7406-1-git-send-email-s.hauer@pengutronix.de>
 <506D84BD.5010000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506D84BD.5010000@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:06:59 up 103 days,  4:18, 65 users,  load average: 9.34, 12.98,
 15.12
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 07:44:45AM -0500, Rob Herring wrote:
> On 10/04/2012 05:39 AM, Sascha Hauer wrote:
> > devicetrees may have the linux,stdout-path property to specify the
> > console. This patch adds support to the i.MX serial driver for this.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> > 
> > I was originally looking for a more generic way to handle this, but
> > since a struct console has no device associated to it, it's not
> > possible to match a console with a device in a generic way. So we
> 
> Could we add a device ptr to struct console?

I think not. Looking at some drivers they register a console very early
when there is no device available (even if there will be a device later
when the uart driver probes)

> >  #ifdef CONFIG_OF
> >  /*
> > + * Check if this device matches the linux,stdout-path property
> > + * in the chosen node. return true if yes, false otherwise
> > + */
> > +static int serial_imx_is_stdoutpath(struct platform_device *pdev)
> 
> Couldn't this function be generic? Just move
> IS_ENABLED(CONFIG_SERIAL_IMX_CONSOLE) outside this function. Arguably,
> the presence of the property or not could replace the config option all
> together.
> 
> And use a struct device so this can work with devices other than
> platform devices (i.e. amba).

Ok, makes sense.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
