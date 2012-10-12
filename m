Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab2JLLFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:05:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62427 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab2JLLFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:05:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 5/8] clk: don't mark clkdev_add_table as init
Date: Fri, 12 Oct 2012 11:05:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>
References: <1349813638-4617-1-git-send-email-arnd@arndb.de> <1349813638-4617-6-git-send-email-arnd@arndb.de> <20121012091535.GD21164@n2100.arm.linux.org.uk>
In-Reply-To: <20121012091535.GD21164@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210121105.09517.arnd@arndb.de>
X-Provags-ID: V02:K0:5ohLqRd/5FoDEQ/lwY6VHrWGqHJlg8mk2z1rvhUUrVg
 wC5fTnrZF7v37TKsGmkPO6MyMdP8jmM8f5bHogvIda9GofpzMz
 3WiP4lMocHkge6X7S3AA7pmlsjbyBe3HZuQri1mkf8jJn/CSdH
 S60Hbsn2/uzM/eGapptFKXD/nHCJe/nwDAe4edzSWE0zdTPfNy
 cyHbWRlc+l5kZ7nsQxw8ed8RiRZcG2eFfb76wyW5wkIecG07pD
 ZkkOUIXKJyWX0w+ukpp9W9YC6V4pIsis0gKu6wF7ANa7DUiULo
 iw8Av+zHZOY29nR46V1t/g581vzeMo0fNwIUEo+wcIuvwyBeRQ
 JOAnhn0b1JDNtfW/GPto=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 October 2012, Russell King - ARM Linux wrote:
> On Tue, Oct 09, 2012 at 10:13:55PM +0200, Arnd Bergmann wrote:
> > s3c2440_clk_add is a subsys_interface method and calls clkdev_add_table,
> > which means we might be calling it after the __init section is
> > discarded.
> > 
> > Without this patch, building mini2440_defconfig results in:
> > 
> > WARNING: vmlinux.o(.text+0x9848): Section mismatch in reference from the function s3c2440_clk_add() to the function .init.text:clkdev_add_table()
> > The function s3c2440_clk_add() references
> > the function __init clkdev_add_table().
> > This is often because s3c2440_clk_add lacks a __init
> > annotation or the annotation of clkdev_add_table is wrong.
> 
> I'm not sure this is the right thing to do.  I suspect this comes from the
> stupidly complex samsung code, and that this is actually safe - I suspect
> that s3c2440_clk_add() needs to be appropriately marked, but then you end
> up having to trace its call path through various structures etc.

Yes, you are right. I have verified now that the only code path into
s3c2440_clk_add() is from "int __init s3c2440_init(void)", so 
s3c2440_clk_add can be marked __init_refok.

I'll follow up with a new patch to replace this one.

	Arnd
