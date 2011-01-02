Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1ABJBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 04:01:22 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51091 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750853Ab1ABJBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 04:01:21 -0500
Date: Sun, 2 Jan 2011 10:01:20 +0100
From: Pavel Machek <pavel@atrey.karlin.mff.cuni.cz>
To: alan@lxorguk.ukuu.org.uk, kernel list <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Subject: Re: VT console need rewrite (fwd)
Message-ID: <20110102090120.GE32469@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes. These days kernel sources and kernel messages both contain
> > non-ASCII characters... as well as many filesystems.
> 
> But not in kernel printed messages.

Even in kernel messages.

               "   ,
On OLPC, I see "CAFE NAND ...: corrected 1 symbol errors"

(old/vendor kernel, through).

It still has:

MODULE_DESCRIPTION("NAND flash driver for OLPC CAFÉ chip");

Aha, yes, bug is there even in new kernel:

static struct pci_driver cafe_nand_pci_driver = {
        .name = "CAFÉ NAND",
        .id_table = cafe_nand_tbl,
        .probe = cafe_nand_probe,
        .remove = __devexit_p(cafe_nand_remove),
        .resume = cafe_nand_resume,
};

That pci_driver.name does leak into
kmsg. ./drivers/mtd/nand/cafe_nand.c . I complained about it before...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

