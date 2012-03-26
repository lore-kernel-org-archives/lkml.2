Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab2CZP3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:29:25 -0400
Received: from ftp.meprolight.com ([194.90.149.17]:52675 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932494Ab2CZP3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:29:23 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
Date: Mon, 26 Mar 2012 17:28:55 +0200
Subject: RE: [PATCH v1] regulator: i.MX35-PDK Add regulator support
Thread-Topic: [PATCH v1] regulator: i.MX35-PDK Add regulator support
Thread-Index: Ac0LX1cllZ5cxVKgRF6ZgANW1v2kiAABGZ6u
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD16@MEP-EXCH.meprolight.com>
References: <1332772593-13313-1-git-send-email-alexg@meprolight.com>,<20120326144712.GA8579@sirena.org.uk>
In-Reply-To: <20120326144712.GA8579@sirena.org.uk>
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


Hi Mark,

Thanks for you quick responds and comments.
 
On Mon, Mar 26, 2012 at 04:36:33PM +0200, Alex Gershgorin wrote:

> +static struct regulator_init_data sw1_init = {
> +     .constraints = {
> +             .name = "SW1",
> +             .min_uV = 600000,
> +             .max_uV = 1375000,
> +             .valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
> +             .valid_modes_mask = 0,
> +             .always_on = 1,
> +             .boot_on = 1,
> +     }
> +};

> >These constraints don't make sense, you've got a voltage range and the
> >ability to change voltages but no consumers so nothing that could ever
> >change the voltage...

Yes, you are right I will add  consumers. 

> +static struct regulator_init_data vpll_init = {
> +     .constraints = {
> +             .name = "VPLL",
> +             .min_uV = 1050000,
> +             .max_uV = 1800000,
> +             .valid_ops_mask = REGULATOR_CHANGE_VOLTAGE,
> +             .boot_on = 1,
> +     }
> +};

> >...and in many cases the supply names don't look like things I'd expect
> >to be varying too much at runtime.  It looks like you just typed the
> >maximum datasheet ranges in, not things that make sense for the board.

It's not quite true, I was based on the Freescale BSP and I assume, that this is checked.
I also tested it on v3.3

Regards,
Alex Gershgorin 

