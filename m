Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab0HQLgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 07:36:54 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:49527
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380Ab0HQLgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 07:36:53 -0400
Date: Tue, 17 Aug 2010 13:36:44 +0200
From: Michael Guntsche <mike@it-loops.com>
To: Brian Norris <norris@broadcom.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [BUG] Nand support broken with v2.6.36-rc1
Message-ID: <20100817113644.GA31317@gibson.comsick.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

Answering my own question here. Yes indeed with the new code a driver
change seems to be needed. The badblock pattern used with this nand is no longer
supported with the stock kernel code. I added this to the nand driver
itself.

static uint8_t scan_ff_pattern[] = { 0xff, 0xff };
static struct nand_bbt_descr rbppc_nand_smallpage = {
  .options = NAND_BBT_SCAN2NDPAGE,
  .offs = NAND_SMALL_BADBLOCK_POS,
  .len = 1,
  .pattern = scan_ff_pattern
};

and the driver is working again. But shouldn't this be supported by the stock level code as well?

Kind regards,
Michael Guntsche

