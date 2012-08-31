Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab2HaK5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 06:57:40 -0400
Received: from antcom.de ([188.40.178.216]:44529 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab2HaK5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 06:57:39 -0400
Message-ID: <504098A1.4050208@antcom.de>
Date: Fri, 31 Aug 2012 12:57:37 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: =?UTF-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>, linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: mxc_nand.c on mach-imx/imx53
References: <5035F84E.3000901@antcom.de> <20120829074122.GV26594@pengutronix.de> <503E3331.8050203@antcom.de> <20120829172820.43bbe68e@eb-e6520> <50407E44.5080408@antcom.de>
In-Reply-To: <50407E44.5080408@antcom.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2012 11:05 AM, Roland Stigge wrote:
> I tried to port this on top of Sascha's patches for imx53, only for mxc v3 for now, as below.
> 
> Unfortunately, I still get:
> 
> ...
> UnCorrectable RS-ECC Error
> UnCorrectable RS-ECC Error
> UnCorrectable RS-ECC Error
> UnCorrectable RS-ECC Error
> UnCorrectable RS-ECC Error
> ...
> 
> from mxc_nand.c's mxc_nand_correct_data_v2_v3(). Maybe there's still sth. missing in the
> error correction code?

With the below incremental fix, it works. :-)

Thanks,

Roland

PS: Will you prepare a patch for l2-mtd.git? I only have an imx53, can't test the v1/v2 etc.
configs.


--- linux-2.6.orig/drivers/mtd/nand/mxc_nand.c
+++ linux-2.6/drivers/mtd/nand/mxc_nand.c
@@ -1141,14 +1141,14 @@ static void mxc_nand_command(struct mtd_
                host->devtype_data->send_cmd(host, command, true);
                mxc_do_addr_cycle(mtd, column, page_addr);
                host->devtype_data->send_read_id(host);
-               host->buf_start = column;
+               host->buf_start = 0;
                break;
 
        case NAND_CMD_PARAM:
                host->devtype_data->send_cmd(host, command, true);
                mxc_do_addr_cycle(mtd, column, page_addr);
                host->devtype_data->send_read_param(host);
-               host->buf_start = column;
+               host->buf_start = 0;
                break;
 
        case NAND_CMD_ERASE1:
