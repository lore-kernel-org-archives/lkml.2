Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2F3McW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 08:32:22 -0400
Received: from antcom.de ([188.40.178.216]:49041 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab2F3McU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 08:32:20 -0400
Message-ID: <4FEEF1D0.5060404@antcom.de>
Date: Sat, 30 Jun 2012 14:32:16 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        dwmw2@infradead.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, hechtb@googlemail.com,
        lars@metafoo.de, b32955@freescale.com, leiwen@marvell.com,
        linux@arm.linux.org.uk,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: Re: [PATCH v10] MTD: LPC32xx MLC NAND driver
References: <1340834129-15545-1-git-send-email-stigge@antcom.de> <1340973434.3070.168.camel@sauron.fi.intel.com>
In-Reply-To: <1340973434.3070.168.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem!

Thanks for the notes!

On 29/06/12 14:37, Artem Bityutskiy wrote:
> Successfully built configuration
> "arm-lpc32xx_defconfig,arm,arm-unknown-linux-gnueabi-", results:
> 
> --- before_patching.log +++ after_patching.log @@ @@ 
> +drivers/mtd/nand/lpc32xx_mlc.c: In function 'lpc32xx_nand_probe': 
> +drivers/mtd/nand/lpc32xx_mlc.c:679:10: warning: variable 'sr' set
> but not used [-Wunused-but-set-variable] 
> +drivers/mtd/nand/lpc32xx_mlc.c:561:24: error: bad constant
> expression [sparse]

This is because sparse doesn't understand this local variable:

uint8_t buf[mtd->writesize];

(but gcc does).

Are you sure we need to support sparse?

The above construction is quite convenient for this case and I'd
prefer this to allocating another buffer dynamically.

Thanks in advance,

Roland
