Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0KIKTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:19:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:57279 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494Ab0KIKTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:19:37 -0500
Message-ID: <4CD91FDD.3030603@kernel.org>
Date: Tue, 09 Nov 2010 11:18:05 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org,
        petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu,
        mfasheh@suse.com, joel.becker@oracle.com, aelder@sgi.com,
        dm-devel@redhat.com, drbd-dev@lists.linbit.com, neilb@suse.de,
        leochen@broadcom.com, sbranden@broadcom.com, chris.mason@oracle.com,
        swhiteho@redhat.com, shaggy@linux.vnet.ibm.com, joern@logfs.org,
        konishi.ryusuke@lab.ntt.co.jp, reiserfs-devel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 4/5] block: make blkdev_get/put() handle exclusive access
References: <1288628129-12811-1-git-send-email-tj@kernel.org> <1288628129-12811-5-git-send-email-tj@kernel.org> <20101103150658.GA5627@quack.suse.cz>
In-Reply-To: <20101103150658.GA5627@quack.suse.cz>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Nov 2010 10:18:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/03/2010 04:06 PM, Jan Kara wrote:
> On Mon 01-11-10 17:15:28, Tejun Heo wrote:
>   The patch looks OK to me as far as ext3, ext4, and reiserfs are
> concerned. One thing I wondered about when I looked at it - does someone
> use the 'mode' argument of the blkdev_put() function (well, apart from the
> exclusive flag)? Because I've looked at a few random disk ->release()
> functions and none of them used it...

Yeah, I thought about removing @mode and make blkdev_put() take
@holder for exclusive releases.  From what I can see, it doesn't seem
like any implementation cares but it's customary to have access to
@mode on ->release(), so I decided to keep it.  It's rather flaky as
there's no mechanism to check or enforce it tho.

Thanks.

-- 
tejun
