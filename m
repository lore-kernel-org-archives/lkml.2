Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab0IAPY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 11:24:58 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:36357 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691Ab0IAPY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 11:24:57 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: PrimeCell generic DMA v10
Date: Wed, 1 Sep 2010 17:24:18 +0200
Message-ID: <1283354665-8673-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is	the tenth iteration of this patchset...

Now DMA	is working nicely on the following platforms and
PrimeCells:

- U300 PL011, PL022, PL180
- U8500	PL011, PL022, PL180
- RealView PB11MPCore PL011, PL022

PL180 (MMC) is not working with	the MMC	and DMA, I haven't
drilled	into why, could	be some	FIFO overflow or similar.
I think	DMA could actually be activated	for all	the RealViews
with a working DMA controller (EB, PB11MPCore, PBA8 and PBX)
but since I cannot test them I left them out of	the patch set.

I ran some serious stress tests	on the PB11MPCore, with	two
threads	submitting DMA memcpy jobs while making	transfers
on PL011 and PL022 simultaneously, no problems.

I read up on DMA-API and proofread all three drivers with
that in	mind, but I cannot find	any more misuses of the
API. (The latest unecessary sync call in PL022 that Russell
found is removed.)

The compilation	problem	Grant saw on the PL022 driver I	have
*still*	not been able to reproduce so I	am in the blue on
this one. It compiles nicely for U300, U8500 and RealView.
I need help if there is	still problems with this.

Yours,
Linus Walleij

