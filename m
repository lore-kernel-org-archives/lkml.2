Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992923Ab2KOIFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:05:05 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40933 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992736Ab2KOIFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:05:03 -0500
Date: Thu, 15 Nov 2012 09:04:53 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH 1/3] OF: Add helper for matching against linux,stdout-path
Message-ID: <20121115080453.GW10369@pengutronix.de>
References: <1351849734-9836-1-git-send-email-s.hauer@pengutronix.de>
 <1351849734-9836-2-git-send-email-s.hauer@pengutronix.de>
 <CACxGe6uW+XN6RDnP+8QFXaCYqqPZO4dZM_aynR6AVMYZT=KuMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6uW+XN6RDnP+8QFXaCYqqPZO4dZM_aynR6AVMYZT=KuMg@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:02:52 up 144 days, 23:14, 34 users,  load average: 8.85, 11.75,
 10.61
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 08:49:54PM +0000, Grant Likely wrote:
> > +int of_device_is_stdout_path(struct device_node *dn)
> > +{
> > +       const char *name;
> > +
> > +       name = of_get_property(of_chosen, "linux,stdout-path", NULL);
> > +       if (name == NULL)
> > +               return 0;
> > +
> > +       if (dn == of_find_node_by_path(name))
> 
> need to of_node_put() the return value of of_find_node_by_path()
> 
> > +               return 1;
> > +
> > +       return 0;
> > +}
> 
> Hi Sascha,
> 
> I'm fine with the helper, but there really is no need for a completely
> separate .c file. Just put it in drivers/of/base.c.

Agreed.

Thanks,
 Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
