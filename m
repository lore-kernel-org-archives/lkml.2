Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2JHQSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 12:18:14 -0400
Received: from masquerade.micron.com ([137.201.242.130]:11505 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab2JHQSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 12:18:11 -0400
From: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: block: Add driver for Micron RealSSD pcie flash cards
Thread-Topic: block: Add driver for Micron RealSSD pcie flash cards
Thread-Index: AQHNpSRl2GkUCeLJCUOltYN04JuaEZevln7A
Date: Mon, 8 Oct 2012 16:17:55 +0000
Message-ID: <80B89753B40C5141A3E2D53FE7A2A8A92CA22DD7@NTXBOIMBX02.micron.com>
References: <20121008071303.GB17400@elgon.mountain>
In-Reply-To: <20121008071303.GB17400@elgon.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.201.88.182]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-19252.005
x-tm-as-result: No--27.443400-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Monday, October 08, 2012 12:13 AM
> To: Sam Bradshaw (sbradshaw)
> Cc: Jens Axboe; linux-kernel@vger.kernel.org
> Subject: re: block: Add driver for Micron RealSSD pcie flash cards
> 
> Hello Sam Bradshaw,
> 
> The patch 88523a61558a: "block: Add driver for Micron RealSSD pcie
> flash cards" from Aug 30, 2011, creates an endian bug:
> drivers/block/mtip32xx/mtip32xx.c:2468 mtip_hw_submit_io()
> 
> drivers/block/mtip32xx/mtip32xx.c
>   2465          fis->opts        = 1 << 7;
>   2466          fis->command     =
>   2467                  (dir == READ ? ATA_CMD_FPDMA_READ : ATA_CMD_FPDMA_WRITE);
>   2468          *((unsigned int *) &fis->lba_low) = (start & 0xFFFFFF);
>                                     ^^^^^^^^^^^^
>   2469          *((unsigned int *) &fis->lba_low_ex) = ((start >> 24) & 0xFFFFFF);
>                                     ^^^^^^^^^^^^^^^
> 
> These addresses point to a series of four unions inside the
> host_to_dev_fis struct.  The unions will be set to different values
> depending on if the CPU is big or little endian.
> 
> If you knew which endianness this works on, then you could probably add
> a cpu_to_be32() or cpu_to_le32().

Thanks for the notification; we'll get a patch out asap.

-Sam
