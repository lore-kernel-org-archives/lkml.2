Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab2JOS5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 14:57:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63287 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab2JOS5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 14:57:20 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: "Philip\, Avinash" <avinashphilip@ti.com>
Cc: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <tony@atomide.com>, afzal@ti.com, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, ivan.djelic@parrot.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] ARM: OMAP2: gpmc: Add support for BCH ECC scheme
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
	<1349274589-11389-4-git-send-email-avinashphilip@ti.com>
Date: Mon, 15 Oct 2012 20:48:30 +0200
In-Reply-To: <1349274589-11389-4-git-send-email-avinashphilip@ti.com> (Avinash
	Philip's message of "Wed, 3 Oct 2012 19:59:48 +0530")
Message-ID: <87vcebvaf5.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> Philip, Avinash <avinashphilip@ti.com> writes:

 > Add support for BCH ECC scheme to gpmc driver and also enabling multi
 > sector read/write. This helps in doing single shot NAND page read and
 > write.

 > ECC engine configurations
 > BCH 4 bit support
 > 1. write => ECC engine configured in wrap mode 6 and with ecc_size0 as 32.
 > 2. read  => ECC engine configured in wrap mode 1 and with ecc_size0 as
 > 13 and ecc_size1 as 1.

 > BCH 8 bit support
 > 1. write => ECC engine configured in wrap mode 6 and with ecc_size0 as 32.
 > 2. read  => ECC engine configured in wrap mode 1 and with ecc_size0 as
 > 26 and ecc_size1 as 2.

 > Note: For BCH8 ECC bytes set to 14 to make compatible with RBL.

On what device? In the am335x TRM (spruh73f.pdf) figure 26-15 (pg 4273)
the rom code is documented to not use any padding on the ECC bytes
(E.G. oob 2..53):

http://www.ti.com/litv/pdf/spruh73f

I see the driver in the u-boot-am33x tree (ti81xx_nand.c) seems to use
4x14 bytes as well though, so perhaps that's a bug in the documentation
instead?

-- 
Bye, Peter Korsgaard
