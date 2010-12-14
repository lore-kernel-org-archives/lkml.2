Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388Ab0LNP1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:27:23 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:50110 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698Ab0LNP1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:27:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IHZfGAfnuUm4gBCBpiAZfFKfn1wufZ1/ZqI2xzkGuqB3socqArCweZ+CWKiSp8adrS
         QGNGH0Ba9/qKl6ha4DlDvJ6dU7rNw8CBl/Nkq4lWQ2VdYF0M1B4DgpVHKjho6H4EapNU
         d35H8EKxzGswx8Z6gRXVJM/EFWmwE6h9QGGLc=
Subject: Re: [PATCH 1/1] mtd: nand: add check for out of page read
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jason Liu <r64343@freescale.com>
Cc: David.Woodhouse@intel.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1290156045-11719-1-git-send-email-r64343@freescale.com>
References: <1290156045-11719-1-git-send-email-r64343@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 17:26:49 +0200
Message-ID: <1292340409.2538.40.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 16:40 +0800, Jason Liu wrote:
> When run mtd_oobtest case, there will be one error for step(4),
> which turned out it need add one check for out of page read in
> nand_do_read_oob just like mtd_do_write_oob did it already.
> This commit also fix one typo error for comments in mtd_do_write_oob
> 
> Signed-off-by: Jason Liu <r64343@freescale.com>

I cannot reproduce this with nandsim, can you?

I tried:

1. sudo modprobe nandsim
   sudo modprobe mtd_oobtest dev=0

2. sudo ./load_nandsim.sh 128 128 2048
   sudo modprobe mtd_oobtest dev=0

In both cases the test passes: "mtd_oobtest: finished with 0 errors"

And in 'nand_do_read_oob()' I see the following piece of code:

        /* Do not allow reads past end of device */
        if (unlikely(from >= mtd->size ||
                     ops->ooboffs + readlen > ((mtd->size >> chip->page_shift) -
                                        (from >> chip->page_shift)) * len)) {
                DEBUG(MTD_DEBUG_LEVEL0, "%s: Attempt read beyond end "
                                        "of device\n", __func__);
                return -EINVAL;
        }

which should handle the case AFAICS.

So, although I did think hard about this, it looks like there is no
problem. What is the kernel version you are looking at? I checked it
with my l2-mtd-2.6.git, which is the latest mtd-2.6.git plus a revert
commit of your patch:

http://git.infradead.org/users/dedekind/l2-mtd-2.6.git

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

