Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab0KMKo0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 05:44:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:60204 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab0KMKoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 05:44:24 -0500
Message-ID: <4CDE6BB2.5070806@kernel.org>
Date: Sat, 13 Nov 2010 11:42:58 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org,
        petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com,
        aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com,
        chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com,
        joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp,
        reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH 1/5] mtd: fix bdev exclusive open bugs in block2mtd::add_device()
References: <1288628129-12811-1-git-send-email-tj@kernel.org>	 <1288628129-12811-2-git-send-email-tj@kernel.org> <1289644735.2218.8.camel@localhost>
In-Reply-To: <1289644735.2218.8.camel@localhost>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Nov 2010 10:43:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/13/2010 11:38 AM, Artem Bityutskiy wrote:
> On Mon, 2010-11-01 at 17:15 +0100, Tejun Heo wrote:
>> +			if (!IS_ERR(bdev)) {
>> +				int ret;
>> +				ret = bd_claim(bdev, dev);
>> +				if (ret) {
>> +					blkdev_put(bdev,
>> +						   FMODE_READ | FMODE_WRITE);
> 
> Would be a bit cleaner to define ea temporary variable:
> 
> fmode_t mode = FMODE_READ | FMODE_WRITE;
> 
> Would you to re-send with this little change please?

Yeap, sure.

> And ideally, 2 independent patches would be nicer because you fix 2
> independent issues.

Hmmm... not really.  The patch is small enough and splitting it won't
really buy as any better bisectability.  Splitting patches into
logical changes is a good thing but it's no religious dogma.  Let's
apply it to the point it actually helps.

Thank you.

-- 
tejun
