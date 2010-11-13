Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0KMKjP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 05:39:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43202 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0KMKjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 05:39:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pwnxgzf1mN0SaBC49Hg7CwyXkWMgDdDOmu5TJkhx9gsO61FFR3KohyYEsaHdIFNQlt
         NJSi8820vTI3BawjoY0S6so59zZp4rRQ0ye3xGwAv+s5Fm0o9nOrr7iHdDXsb05z9zxQ
         0j/OOQ3/nIOYB8M6sBpC0lwoooNxrDryvGGXc=
Subject: Re: [PATCH 1/5] mtd: fix bdev exclusive open bugs in
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
In-Reply-To: <1288628129-12811-2-git-send-email-tj@kernel.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
	 <1288628129-12811-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Nov 2010 12:38:55 +0200
Message-ID: <1289644735.2218.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2010-11-01 at 17:15 +0100, Tejun Heo wrote:
> +			if (!IS_ERR(bdev)) {
> +				int ret;
> +				ret = bd_claim(bdev, dev);
> +				if (ret) {
> +					blkdev_put(bdev,
> +						   FMODE_READ | FMODE_WRITE);

Would be a bit cleaner to define ea temporary variable:

fmode_t mode = FMODE_READ | FMODE_WRITE;

Would you to re-send with this little change please?

And ideally, 2 independent patches would be nicer because you fix 2
independent issues.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

