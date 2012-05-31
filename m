Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab2EaOIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:08:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757948Ab2EaOI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:08:28 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com,
        jlbec@evilplan.org, bcrl@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, joe.jin@oracle.com
Subject: Re: [PATCH 1/2] aio: make kiocb->private NUll in init_sync_kiocb()
References: <1338437550-24499-1-git-send-email-junxiao.bi@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 31 May 2012 10:08:13 -0400
In-Reply-To: <1338437550-24499-1-git-send-email-junxiao.bi@oracle.com>
	(Junxiao Bi's message of "Thu, 31 May 2012 12:12:29 +0800")
Message-ID: <x49k3zscuk2.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junxiao Bi <junxiao.bi@oracle.com> writes:

> Ocfs2 uses kiocb.*private as a flag of unsigned long size. In
> commit a11f7e6 ocfs2: serialize unaligned aio, the unaligned
> io flag is involved in it to serialize the unaligned aio. As
> *private is not initialized in init_sync_kiocb() of do_sync_write(),
> this unaligned io flag may be unexpectly set in an aligned dio.
> And this will cause OCFS2_I(inode)->ip_unaligned_aio decreased
> to -1 in ocfs2_dio_end_io(), thus the following unaligned dio
> will hang forever at ocfs2_aiodio_wait() in ocfs2_file_write_iter().

> We can't initialized this flag in ocfs2_file_write_iter() since
> it may be invoked several times by do_sync_write(). So we initialize
> it in init_sync_kiocb(), it's also useful for other similiar use of
> it in the future.

I don't see any ocfs2_file_write_iter in the upstream kernel.
ocfs2_file_aio_write most certainly could set ->private to 0, it
will only be called once for a given kiocb.

That point aside, I have no issues with setting private to NULL in
init_sync_kiocb.  If you fix up the comment to reflect reality
w.r.t. the upstream kernel source, I'll ack the patch.

Cheers,
Jeff
