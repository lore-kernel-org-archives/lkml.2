Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0IWLiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:38:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab0IWLit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:38:49 -0400
Date: Thu, 23 Sep 2010 13:38:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ralph Campbell <ralph.campbell@qlogic.com>
Cc: Joe Perches <joe@perches.com>, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/13] drivers/infiniband: Remove unnecessary casts of
 private_data
In-Reply-To: <1283883869.32259.13.camel@chromite.mv.qlogic.com>
Message-ID: <alpine.LNX.2.00.1009231338300.26813@pobox.suse.cz>
References: <cover.1283650107.git.joe@perches.com>  <a13edeb14cc926b71e21daff892acbe2d76313ab.1283650107.git.joe@perches.com> <1283883869.32259.13.camel@chromite.mv.qlogic.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Sep 2010, Ralph Campbell wrote:

> Acked-by: Ralph Campbell <ralph.campbell@qlogic.com>

Applied, thanks.

> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  drivers/infiniband/hw/qib/qib_file_ops.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
> > index 6b11645..cef5d67 100644
> > --- a/drivers/infiniband/hw/qib/qib_file_ops.c
> > +++ b/drivers/infiniband/hw/qib/qib_file_ops.c
> > @@ -1722,7 +1722,7 @@ static int qib_close(struct inode *in, struct file *fp)
> >  
> >  	mutex_lock(&qib_mutex);
> >  
> > -	fd = (struct qib_filedata *) fp->private_data;
> > +	fd = fp->private_data;
> >  	fp->private_data = NULL;
> >  	rcd = fd->rcd;
> >  	if (!rcd) {
> > @@ -1808,7 +1808,7 @@ static int qib_ctxt_info(struct file *fp, struct qib_ctxt_info __user *uinfo)
> >  	struct qib_ctxtdata *rcd = ctxt_fp(fp);
> >  	struct qib_filedata *fd;
> >  
> > -	fd = (struct qib_filedata *) fp->private_data;
> > +	fd = fp->private_data;
> >  
> >  	info.num_active = qib_count_active_units();
> >  	info.unit = rcd->dd->unit;

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
