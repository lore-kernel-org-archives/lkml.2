Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab2KUPEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:04:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943Ab2KUPEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:04:32 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk,
        tytso@mit.edu, david@fromorbit.com, bpm@sgi.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 3/9] xfs: factor out everything but the filemap_write_and_wait from xfs_file_fsync
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
	<20121120074138.24645.36708.stgit@blackbox.djwong.org>
	<20121121100913.GF23339@infradead.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 21 Nov 2012 09:10:35 -0500
In-Reply-To: <20121121100913.GF23339@infradead.org> (Christoph Hellwig's
	message of "Wed, 21 Nov 2012 05:09:13 -0500")
Message-ID: <x49mwybujvo.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Mon, Nov 19, 2012 at 11:41:38PM -0800, Darrick J. Wong wrote:
>> Hi,
>> 
>> Fsyncing is tricky business, so factor out the bits of the xfs_file_fsync
>> function that can be used from the I/O post-processing path.
>
> Why would we need to skip the filemap_write_and_wait_range call here?
> If we're doing direct I/O we should not have any pages in this regions
> anyway.  You're also not skipping it in the generic implementation as
> far as I can see, so I see no point in doing it just in XFS.

OK, I'll fix that.

Thanks!
Jeff
