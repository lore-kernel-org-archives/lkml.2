Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761478Ab2FEJbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:31:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39273 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761458Ab2FEJbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:31:09 -0400
Date: Tue, 5 Jun 2012 18:31:03 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, jmoyer@redhat.com,
        mfasheh@suse.com, jlbec@evilplan.org, bcrl@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        joe.jin@oracle.com, dave.kleikamp@oracle.com
Subject: Re: [V2 PATCH 1/2] aio: make kiocb->private NUll in init_sync_kiocb()
Message-ID: <20120605093103.GA21560@kroah.com>
References: <1338881210-14863-1-git-send-email-junxiao.bi@oracle.com>
 <1338881210-14863-2-git-send-email-junxiao.bi@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338881210-14863-2-git-send-email-junxiao.bi@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 03:26:49PM +0800, Junxiao Bi wrote:
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
> ---
>  include/linux/aio.h |    1 +
>  1 file changed, 1 insertion(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
