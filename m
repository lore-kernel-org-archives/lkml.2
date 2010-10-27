Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125Ab0J0Qbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:31:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49442 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab0J0Qbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:31:45 -0400
Date: Wed, 27 Oct 2010 18:31:40 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Nguyen Dinh-R00091 <R00091@freescale.com>
Cc: Eric =?iso-8859-15?Q?B=E9nard?= <eric@eukrea.com>,
        Grant Likely <grant.likely@secretlab.ca>, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        valentin.longchamp@epfl.ch
Subject: Re: [PATCH] ARM: imx: Add some core definitions for MX53
Message-ID: <20101027163140.GN6017@pengutronix.de>
References: <1288119235-7036-1-git-send-email-Dinh.Nguyen@freescale.com> <20101027082958.GA6797@angua.secretlab.ca> <20101027090921.GB8554@pengutronix.de> <20101027102253.GA7822@angua.secretlab.ca> <20101027132213.GJ6017@pengutronix.de> <4CC82A13.8000909@eukrea.com> <20101027135642.GM6017@pengutronix.de> <86A0E76937111F4C92FABEC0A2098851051D6523@az33exm21>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86A0E76937111F4C92FABEC0A2098851051D6523@az33exm21>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:08:32 up 116 days,  7:19, 48 users,  load average: 0.06, 0.10,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 07:57:11AM -0700, Nguyen Dinh-R00091 wrote:
> >
> >Yes, I know. Is MX5_1_3 better? Any other suggestions?
> 
> Not sure why we can't do something like this?
> 
> In mx5x.h, 
> MX51_PERIP_1 /* Address specific to mx51 */
> MX53_PERIP_1 /* Address specific to mx53 */
> MX5_PERIP_2 /* Address that is shared to mx51, mx53, and any later mx5X chips */

The problem is that we don't know about 'any later chips' and we don't
know whether the MX5_ assumption stays true for later MX5 chips.

To end this, let's just use the complete names for all i.MX defines,
that is MX51 for MX51 and MX53 for MX53. It's the only way to handle
this consistently for *all* i.MX, not only the MX5 ones.

Uwe has worked a lot on making the overhead for this as little s
possible and in the end we are just talking about a handfull of base
addresses and interrupt/dma request numbers. It should be simple to add
them without asking the question 'is this mxx specific or mxy also?'
over and over again.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
