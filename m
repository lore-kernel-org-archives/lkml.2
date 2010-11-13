Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab0KMLOp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 06:14:45 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57540 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab0KMLOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 06:14:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rdzM8+1YLG9ZTwKWAUMerXMUx5vfJ9N15lFFqbCnFLA5TrdJEyK3DpvwhvyAKQck0r
         sy8r009qOoPgTHU198CXRLTIPdQC2up4R+rIJalZQpsKOR+djCm3Bfj7D26kPjdW+jtw
         v92f4KAc5L+jfYwtb6iWZzwmqrlG3FRW1H8zk=
Subject: Re: [PATCH UPDATED 1/5] mtd: fix bdev exclusive open bugs in
 block2mtd::add_device()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org,
        petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com,
        aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com,
        chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com,
        joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp,
        reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-mtd@lists.infradead.org
In-Reply-To: <4CDE6FAA.9030605@kernel.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
	 <1288628129-12811-2-git-send-email-tj@kernel.org>
	 <4CDE6FAA.9030605@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Nov 2010 13:14:25 +0200
Message-ID: <1289646865.2218.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-13 at 11:59 +0100, Tejun Heo wrote:
> There are two bdev exclusive open bugs.
> 
> * open_bdev_exclusive() must not be called with NULL holder.  Use dev
>   as the holder.
> 
> * open_by_devnum() doesn't open the bdev exclusively but
>   block2mtd_free_device() always assumes it.  Explicitly claim the
>   bdev.
> 
> The latter is rather clumsy but will be simplified with future
> blkdev_get/put() cleanups.
> 
> - Updated to use local variable @mode to cache FMODE_* masks as
>   suggested by Artem Bityutskiy.

Do you want this patch to go in via Jens' tree with the rest of the
series, or as an independent patch via the mtd tree?

Anyway,

Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

