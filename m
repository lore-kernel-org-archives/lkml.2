Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030297Ab2CTN6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:58:23 -0400
Received: from mail.meprolight.com ([194.90.149.17]:42591 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965025Ab2CTN6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:58:21 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: "'Sascha Hauer'" <s.hauer@pengutronix.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
Date: Tue, 20 Mar 2012 15:57:52 +0200
Subject: RE: [PATCH] ARM: i.MX35: Add set_rate and round_rate calls to
	csi_clk
Thread-Topic: [PATCH] ARM: i.MX35: Add set_rate and round_rate calls to
	csi_clk
Thread-Index: Ac0GmnuSvqZ1Ho1lQp270BBshFUrYwAAMNng
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CC34C59E5@MEP-EXCH.meprolight.com>
In-Reply-To: <20120320130805.GK3852@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Sascha,

Thanks for you comments.

On Tue, Mar 20, 2012 at 12:29:52PM +0200, Alex Gershgorin wrote:
> This patch add set_rate and round_rate calls to csi_clk. This is needed
> to give mx3-camera control over master clock rate to camera.

> >The file you are patching is scheduled for removal in favour for the
> >common clock framework, so you are flogging a dead horse here. I suggest
> >that you wait some time until I finished the i.MX35 patches for this.

This patch allows me to move forward, without this patch the camera just does not work. I'll use it as a temporary patch and happily wait for you to finish your work on i.MX35 patches :-)
 
> +static int csi_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	unsigned long div;
> +	unsigned long parent_rate;
> +	unsigned long pdr2 = __raw_readl(CCM_BASE + CCM_PDR2);
> +
> +	if (pdr2 & (1 << 7))
> +		parent_rate = get_rate_arm();
> +	else
> +		parent_rate = get_rate_ppll();
> +
> +	div = parent_rate / rate;
> +
> +	/* Set clock divider */
> +	pdr2 |= ((div - 1) & 0x3f) << 16;

> >btw you forget to clear the divider bits in pdr2 before
> >setting the new values.

 Totally agree with you.



Regards,
Alex Gershgorin


