Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab2EBUVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:21:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50459 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab2EBUVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:21:06 -0400
Date: Wed, 2 May 2012 22:21:01 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Rob Lee <rob.lee@linaro.org>
Cc: linaro-dev@lists.linaro.org, patches@linaro.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, amit.kucheria@linaro.org,
        jj@chaosbits.net, kernel@pengutronix.de, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] ARM: imx: Add common imx cpuidle init
 functionality.
Message-ID: <20120502202101.GA16535@pengutronix.de>
References: <1335924760-796-1-git-send-email-rob.lee@linaro.org>
 <1335924760-796-2-git-send-email-rob.lee@linaro.org>
 <20120502072701.GR4141@pengutronix.de>
 <CAMXH7KGLHD8uimSnf8=0t15F7KcFiPuL=3bebY309MbaA75USA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMXH7KGLHD8uimSnf8=0t15F7KcFiPuL=3bebY309MbaA75USA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:13:40 up 172 days,  4:00, 30 users,  load average: 0.01, 0.15,
 0.54
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 02:16:36PM -0500, Rob Lee wrote:
> Sascha,
> 
> >> +int __init imx_cpuidle_init(struct cpuidle_driver *drv)
> >> +{
> >> +     struct cpuidle_device *dev;
> >> +     int cpu_id, ret;
> >> +
> >> +     if (!drv || drv->state_count > CPUIDLE_STATE_MAX) {
> >
> > Please don't check for !drv here. When someone calls this function with
> > a NULL pointer he should get a nive stack trace allowing him to figure
> > out what went wrong.
> >
> 
> Ok, I will change this in v3.  Given your statement, my understanding
> is that I should avoid adding checks to make sure a valid driver
> object was given as the stack trace information is all the handling
> that is needed.  If there is any further logic needed in that rule,
> could you elaborate so that I don't make this mistake in the future,
> or so that I don't add a check on a driver object in a case that I
> should?

Here we have the case that only a Kernel developer will add a call to
this function. For a kernel developer a stack trace is more useful
than a pr_err. Of course this is different when not testing for a NULL
pointer causes subtle bugs in unrelated code.

> >
> > You should only unregister the cpuidle devices you successfully
> > registered. Unregistering not yet registered cpuidle devices probably
> > has unwanted side effects.
> >
> 
> I did not add in this handling because the cpuidle_unregister_device()
> call already has a "registered" check so extra handling seemed
> unnecessary.  But if you still think it is needed just let me know.
> 

It's ok then. I didn't check cpuidle_unregister_device.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
