Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab0IMQ7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:59:07 -0400
Received: from be1ssnxpe1.nxp.com ([57.67.164.69]:59674 "EHLO
	be1ssnxpe1.nxp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab0IMQ7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:59:06 -0400
From: Kevin Wells <kevin.wells@nxp.com>
To: Kevin Wells <wellsk40@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rabin.vincent@stericsson.com" <rabin.vincent@stericsson.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "srinidhi.kasagar@stericsson.com" <srinidhi.kasagar@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
CC: "quentinyang05@gmail.com" <quentinyang05@gmail.com>,
        "Lukasz.Baj@tieto.com" <Lukasz.Baj@tieto.com>
Date: Mon, 13 Sep 2010 18:51:57 +0200
Subject: RE: resend: [PATCH] amba_pl022: Setup SPI configuration based on
 spi->mode
Thread-Topic: resend: [PATCH] amba_pl022: Setup SPI configuration based on
 spi->mode
Thread-Index: ActRO50ABG4m5hg5SM+0vA2KCYZEMwCJ10kA
Message-ID: <083DF309106F364B939360100EC290F80AD49D5230@eu1rdcrdc1wx030.exi.nxp.com>
References: <AANLkTikbKwo9=xLWo1qEcc2E5aa2iN2F_KCokJPpnWOk@mail.gmail.com>
In-Reply-To: <AANLkTikbKwo9=xLWo1qEcc2E5aa2iN2F_KCokJPpnWOk@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000 definitions=2010-09-13_05:2010-09-13,2010-09-13,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +       if (spi->mode & SPI_CPOL)
> +               tmp = SSP_CLK_POL_IDLE_HIGH;
> +       else
> +               tmp = SSP_CLK_POL_IDLE_LOW;
> +       SSP_WRITE_BITS(chip->cr0, tmp, SSP_CR0_MASK_SPO, 6);
> +
> +       if (spi->mode & SPI_CPHA)
> +               tmp = SSP_CLK_SECOND_EDGE;
> +       else
> +               tmp = SSP_CLK_FIRST_EDGE;
> +       SSP_WRITE_BITS(chip->cr0, tmp, SSP_CR0_MASK_SPH, 6);

SSP_CR0_MASK_SPH (SPHA) should use bit 7, not bit 6.
Should be:
       SSP_WRITE_BITS(chip->cr0, tmp, SSP_CR0_MASK_SPH, 7);

> +
>        SSP_WRITE_BITS(chip->cr0, chip_info->clk_freq.scr, SSP_CR0_MASK_SCR,
> 8);
>        /* Loopback is available on all versions except PL023 */

