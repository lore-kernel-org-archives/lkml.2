Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab2ICIzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:55:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36309 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab2ICIzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:55:18 -0400
Date: Mon, 3 Sep 2012 10:55:17 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: Eric =?iso-8859-15?Q?B=E9nard?= <eric@eukrea.com>,
        linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: mxc_nand.c on mach-imx/imx53
Message-ID: <20120903085517.GE26594@pengutronix.de>
References: <5035F84E.3000901@antcom.de>
 <20120829074122.GV26594@pengutronix.de>
 <503E3331.8050203@antcom.de>
 <20120829172820.43bbe68e@eb-e6520>
 <50407E44.5080408@antcom.de>
 <504098A1.4050208@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504098A1.4050208@antcom.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:53:37 up 72 days, 5 min, 74 users,  load average: 1.07, 0.71,
 0.49
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 12:57:37PM +0200, Roland Stigge wrote:
> On 08/31/2012 11:05 AM, Roland Stigge wrote:
> > I tried to port this on top of Sascha's patches for imx53, only for mxc v3 for now, as below.
> > 
> > Unfortunately, I still get:
> > 
> > ...
> > UnCorrectable RS-ECC Error
> > UnCorrectable RS-ECC Error
> > UnCorrectable RS-ECC Error
> > UnCorrectable RS-ECC Error
> > UnCorrectable RS-ECC Error

Have you written the data you are unable to read with this driver?

> > ...
> > 
> > from mxc_nand.c's mxc_nand_correct_data_v2_v3(). Maybe there's still sth. missing in the
> > error correction code?
> 
> With the below incremental fix, it works. :-)
> 
> Thanks,
> 
> Roland
> 
> PS: Will you prepare a patch for l2-mtd.git? I only have an imx53, can't test the v1/v2 etc.
> configs.
> 
> 
> --- linux-2.6.orig/drivers/mtd/nand/mxc_nand.c
> +++ linux-2.6/drivers/mtd/nand/mxc_nand.c
> @@ -1141,14 +1141,14 @@ static void mxc_nand_command(struct mtd_
>                 host->devtype_data->send_cmd(host, command, true);
>                 mxc_do_addr_cycle(mtd, column, page_addr);
>                 host->devtype_data->send_read_id(host);
> -               host->buf_start = column;
> +               host->buf_start = 0;
>                 break;
>  
>         case NAND_CMD_PARAM:
>                 host->devtype_data->send_cmd(host, command, true);
>                 mxc_do_addr_cycle(mtd, column, page_addr);
>                 host->devtype_data->send_read_param(host);
> -               host->buf_start = column;
> +               host->buf_start = 0;

On what tree are you working? I cannot find a handling of
NAND_CMD_PARAM in my tree.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
