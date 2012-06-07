Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077Ab2FGPJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:09:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab2FGPJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:09:56 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com,
        jlbec@evilplan.org, bcrl@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, joe.jin@oracle.com, dave.kleikamp@oracle.com
Subject: Re: [V2 PATCH 1/2] aio: make kiocb->private NUll in init_sync_kiocb()
References: <1338881210-14863-1-git-send-email-junxiao.bi@oracle.com>
	<1338881210-14863-2-git-send-email-junxiao.bi@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 07 Jun 2012 11:09:26 -0400
In-Reply-To: <1338881210-14863-2-git-send-email-junxiao.bi@oracle.com>
	(Junxiao Bi's message of "Tue, 5 Jun 2012 15:26:49 +0800")
Message-ID: <x49zk8f9n15.fsf@segfault.boston.devel.redhat.com>
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
> will hang forever at ocfs2_aiodio_wait() in ocfs2_file_aio_write().
>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

Acked-by: Jeff Moyer <jmoyer@redhat.com>
