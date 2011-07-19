Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab1GSPXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 11:23:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42527 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab1GSPX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 11:23:29 -0400
Date: Tue, 19 Jul 2011 17:23:23 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: Re: [PATCH] gpio/mxc/mxs: fix build error introduced by the reanming
 of irq_gc_ack()
Message-ID: <20110719152323.GA6628@pengutronix.de>
References: <1311046444-25423-1-git-send-email-shawn.guo@linaro.org>
 <4E257ACD.6080608@ru.mvista.com>
 <20110719125917.GK3838@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110719125917.GK3838@S2100-06.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Shawn,

> > >  	ct = gc->chip_types;
> > >-	ct->chip.irq_ack = irq_gc_ack,
> > >+	ct->chip.irq_ack = irq_gc_ack_set_bit,
> > 
> >    There should be semicolon rathern than comma at the end.
> > 
> Thanks, Sergei.  I'm pretty surprised that gcc did not help me there.
> > >  	ct->chip.irq_mask = irq_gc_mask_clr_bit;
That's because using a comma is valid C, too.
It just assigns ct->chip.irq_ack as a side effect of the
expression

	ct->chip.irq_ack = irq_gc_ack_set_bit, ct->chip.irq_unmask = irq_gc_mask_set_bit;

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
