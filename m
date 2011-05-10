Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab1EJNNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:13:08 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:50830 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab1EJNNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:13:06 -0400
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
Date: Tue, 10 May 2011 22:12:54 +0900
In-Reply-To: <20110510123819.GB4402@quack.suse.cz> (Jan Kara's message of
	"Tue, 10 May 2011 14:38:19 +0200")
Message-ID: <87hb924s2x.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> I'd like to know those patches are on what state. Waiting in writeback
>> page makes slower, like you mentioned it (I guess it would more
>> noticeable if device was slower that like FAT uses). And I think
>> currently it doesn't help anything others for blk-integrity stuff
>> (without other technic, it doesn't help FS consistency)?
>> 
>> So, why is this locking stuff enabled always? I think it would be better
>> to enable only if blk-integrity stuff was enabled.
>> 
>> If it was more sophisticate but more complex stuff (e.g. use
>> copy-on-write technic for it), I would agree always enable though.
>   Well, also software RAID generally needs this feature (so that parity
> information / mirror can be properly kept in sync). Not that I'd advocate
> that this feature must be always enabled, it's just that there are also
> other users besides blk-integrity.

I see. So many block layer stuff sounds like broken on corner case? If
so, I more feel this approach should be temporary workaround, and should
use another less-blocking approach.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
