Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab1CAQmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:42:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47037 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab1CAQmG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:42:06 -0500
MIME-Version: 1.0
In-Reply-To: <20110301175425.50296d21.sfr@canb.auug.org.au>
References: <20110301175425.50296d21.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 1 Mar 2011 09:41:45 -0700
X-Google-Sender-Auth: el7SAF5r--ljSkIpKdAZCsmUqtA
Message-ID: <AANLkTi=emhx8tZ-SqZok7oMPpcXiYUr+b1t3CMgeAxao@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (devicetree tree related)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 11:54 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> drivers/mtd/nand/pasemi_nand.c:221: error: variable 'pasemi_nand_driver' has initializer but incomplete type
> drivers/mtd/nand/pasemi_nand.c:223: error: unknown field 'driver' specified in initializer
> drivers/mtd/nand/pasemi_nand.c:223: error: extra brace group at end of initializer
> drivers/mtd/nand/pasemi_nand.c:223: error: (near initialization for 'pasemi_nand_driver')
> drivers/mtd/nand/pasemi_nand.c:227: warning: excess elements in struct initializer
> drivers/mtd/nand/pasemi_nand.c:227: warning: (near initialization for 'pasemi_nand_driver')
> drivers/mtd/nand/pasemi_nand.c:228: error: unknown field 'probe' specified in initializer
> drivers/mtd/nand/pasemi_nand.c:228: warning: excess elements in struct initializer
> drivers/mtd/nand/pasemi_nand.c:228: warning: (near initialization for 'pasemi_nand_driver')
> drivers/mtd/nand/pasemi_nand.c:229: error: unknown field 'remove' specified in initializer
> drivers/mtd/nand/pasemi_nand.c:229: warning: excess elements in struct initializer
> drivers/mtd/nand/pasemi_nand.c:229: warning: (near initialization for 'pasemi_nand_driver')
> drivers/mtd/nand/pasemi_nand.c: In function 'pasemi_nand_init':
> drivers/mtd/nand/pasemi_nand.c:234: warning: passing argument 1 of 'platform_driver_register' from incompatible pointer type
> include/linux/platform_device.h:124: note: expected 'struct platform_driver *' but argument is of type 'struct latform_driver *'
> drivers/mtd/nand/pasemi_nand.c: In function 'pasemi_nand_exit':
> drivers/mtd/nand/pasemi_nand.c:240: warning: passing argument 1 of 'platform_driver_unregister' from incompatible pointer type
> include/linux/platform_device.h:125: note: expected 'struct platform_driver *' but argument is of type 'struct latform_driver *'
>
> Caused by commit ac677e82cd5c031a010458304821bb8b1e47cf24 ("dt: Eliminate
> of_platform_{,un}register_driver").  Looks like a typo to me :-)

Indeed!  Fix pushed out.  Thanks.

g.
