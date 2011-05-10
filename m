Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab1EJNqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:46:23 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:35143 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab1EJNqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:46:21 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Theodore Tso <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
Subject: Re: [PATCHSET v3.1 0/7] data integrity: Stabilize pages during writeback for various fses
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
	<87tyd31fkc.fsf@devron.myhome.or.jp>
	<20110510123819.GB4402@quack.suse.cz>
	<87hb924s2x.fsf@devron.myhome.or.jp>
	<20110510132953.GE4402@quack.suse.cz>
Date: Tue, 10 May 2011 22:46:16 +0900
In-Reply-To: <20110510132953.GE4402@quack.suse.cz> (Jan Kara's message of
	"Tue, 10 May 2011 15:29:53 +0200")
Message-ID: <878vue4qjb.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> I see. So many block layer stuff sounds like broken on corner case? If
>> so, I more feel this approach should be temporary workaround, and should
>> use another less-blocking approach.
>   Not many but some... The alternative to less blocking approach is to do
> copy-out before a page is submitted for IO (or various middle ground
> alternatives of doing sometimes copyout, sometimes blocking...). That costs
> some performance as well. We talked about it at LSF and the approach
> Darrick is implementing was considered the least intrusive. There's really
> no way to fix these corner cases and keep performance.

You already considered, to copy only if page was writeback (like
copy-on-write). I.e. if page is on I/O, copy, then switch the page for
writing new data.

Yes, it is complex. But I think blocking and overhead is minimum, and
this can be used as infrastructure for copy-on-write FS.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
