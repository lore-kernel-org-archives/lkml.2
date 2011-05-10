Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab1EJNwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:52:19 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:58858 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab1EJNwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:52:14 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Theodore Tso <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
Subject: Re: [PATCHSET v3.1 0/7] data integrity: Stabilize pages during writeback for various fses
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
	<87tyd31fkc.fsf@devron.myhome.or.jp>
	<20110510133603.GA5823@infradead.org>
Date: Tue, 10 May 2011 22:52:10 +0900
In-Reply-To: <20110510133603.GA5823@infradead.org> (Christoph Hellwig's
	message of "Tue, 10 May 2011 09:36:03 -0400")
Message-ID: <874o524q9h.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Tue, May 10, 2011 at 10:59:15AM +0900, OGAWA Hirofumi wrote:
>> I'd like to know those patches are on what state. Waiting in writeback
>> page makes slower, like you mentioned it (I guess it would more
>> noticeable if device was slower that like FAT uses). And I think
>> currently it doesn't help anything others for blk-integrity stuff
>> (without other technic, it doesn't help FS consistency)?
>
> It only makes things slower if we rewrite a region in a file that is
> currently undergoing writeback. I'd be interested to know about real
> life applications doing that, and if they really are badly affect we
> should help them to work around that in userspace, e.g. by adding a
> fadvice will rewrite call that might be used to never write back that
> regions without an explicit fsync call.

Isn't it reallocated blocks too, and metadata too?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
