Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab0IGSYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 14:24:35 -0400
Received: from avexcashub1.qlogic.com ([198.70.193.61]:53811 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab0IGSYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 14:24:31 -0400
Subject: Re: [PATCH 02/13] drivers/infiniband: Remove unnecessary casts of
 private_data
From: Ralph Campbell <ralph.campbell@qlogic.com>
To: Joe Perches <joe@perches.com>
CC: Jiri Kosina <trivial@kernel.org>, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <a13edeb14cc926b71e21daff892acbe2d76313ab.1283650107.git.joe@perches.com>
References: <cover.1283650107.git.joe@perches.com>
	 <a13edeb14cc926b71e21daff892acbe2d76313ab.1283650107.git.joe@perches.com>
Content-Type: text/plain; charset="us-ascii"
Organization: QLogic
Date: Tue, 7 Sep 2010 11:24:29 -0700
Message-ID: <1283883869.32259.13.camel@chromite.mv.qlogic.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Ralph Campbell <ralph.campbell@qlogic.com>

On Sat, 2010-09-04 at 18:52 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/infiniband/hw/qib/qib_file_ops.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
> index 6b11645..cef5d67 100644
> --- a/drivers/infiniband/hw/qib/qib_file_ops.c
> +++ b/drivers/infiniband/hw/qib/qib_file_ops.c
> @@ -1722,7 +1722,7 @@ static int qib_close(struct inode *in, struct file *fp)
>  
>  	mutex_lock(&qib_mutex);
>  
> -	fd = (struct qib_filedata *) fp->private_data;
> +	fd = fp->private_data;
>  	fp->private_data = NULL;
>  	rcd = fd->rcd;
>  	if (!rcd) {
> @@ -1808,7 +1808,7 @@ static int qib_ctxt_info(struct file *fp, struct qib_ctxt_info __user *uinfo)
>  	struct qib_ctxtdata *rcd = ctxt_fp(fp);
>  	struct qib_filedata *fd;
>  
> -	fd = (struct qib_filedata *) fp->private_data;
> +	fd = fp->private_data;
>  
>  	info.num_active = qib_count_active_units();
>  	info.unit = rcd->dd->unit;


