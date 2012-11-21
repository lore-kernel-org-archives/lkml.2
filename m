Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab2KUOJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:09:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591Ab2KUOJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:09:58 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk,
        tytso@mit.edu, david@fromorbit.com, bpm@sgi.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 2/9] ext4: honor the O_SYNC flag for aysnchronous direct I/O requests
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120074131.24645.38489.stgit@blackbox.djwong.org>
	<20121120100751.GB1408@quack.suse.cz>
	<x49sj84hwl4.fsf@segfault.boston.devel.redhat.com>
	<20121121005626.GC10507@quack.suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 21 Nov 2012 09:09:41 -0500
In-Reply-To: <20121121005626.GC10507@quack.suse.cz> (Jan Kara's message of
	"Wed, 21 Nov 2012 01:56:26 +0100")
Message-ID: <x49r4nnujx6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> Just to be clear, are you saying you would like me to remove the
>> mutex_lock/unlock pair from ext4_sync_file?  (I had already factored out
>> the common code between this new code path and the fsync path in my tree.)
>   Yes, after some thinking I came to that conclusion. We actually need to
> keep i_mutex around ext4_flush_unwritten_io() to avoid livelocks but the
> rest doesn't need it. The change should be definitely a separate patch just
> in case there's something subtle I missed and we need to bisect in
> future... I've attached a patch for that so that blame for bugs goes my way
> ;) Compile tested only so far. I'll give it some more testing overnight.

Great, thanks Jan!  I'll include this in the next posting.

Cheers,
Jeff
