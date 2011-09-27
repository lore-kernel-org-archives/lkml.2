Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab1I0Mzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:55:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53803 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1I0Mzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:55:50 -0400
Subject: Re: [PATCH V5] mtd: Add DiskOnChip G3 support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 27 Sep 2011 15:58:37 +0300
In-Reply-To: <1316805250-11105-1-git-send-email-robert.jarzmik@free.fr>
References: <1316702729.4849.114.camel@sauron>
	 <1316805250-11105-1-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317128326.6207.30.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 21:14 +0200, Robert Jarzmik wrote:
> Add support for DiskOnChip G3 chips. The support is quite
> limited yet :
>  - no flash writes/erases are implemented
>  - ECC fixes are not implemented
>  - powerdown is not implemented
>  - IPL handling is not yet done
> 
> On the brighter side, the chip reading does work.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

Sparse complains:

[dedekind@sauron l2-mtd-2.6 (master)]$ make C=1
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CHECK   drivers/mtd/devices/docg3.c
drivers/mtd/devices/docg3.h:217:21: error: dubious one-bit signed bitfield

And indeed:

        int device_id:4;
        int if_cfg:1;

should be unsigned int bit-fields, not signed.

-- 
Best Regards,
Artem Bityutskiy

